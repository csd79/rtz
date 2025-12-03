;;; -*- Msode: Common-Lisp; Author: denes.cselovszky@gmail.com -*-
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; General


(defun string->symbol (arg)
  "If ARG is a string, convert it to a symbol."
  (typecase arg
    (symbol arg)
    (string (intern (string-upcase arg)))
    (t      nil)))


(defun symbol->string (arg)
  "If ARG is a symbol, convert it to a string."
  (typecase arg
    (symbol (symbol-name arg))
    (string arg)
    (t      nil)))


(defun rmapcar (function sequence)
  "Recursive version of mapcar for a single SEQUENCE (of sequences) argument."
  (mapcar #'(lambda (element)
              (if (sequencep element)
                (rmapcar function element)
                (funcall function element)))
          (coerce sequence 'list)))


#|(defun synonym= (thing-1 thing-2 synonyms &key (test #'astring=))
  "Compare 2 strings (or other things) using a synonyms dictionary."
  (let ((candidates (apply #'nconc (remove-if-not
                                    #'(lambda (row)
                                        (member thing-1 row :test test))
                                    synonyms))))
    (member thing-2 candidates :test test)))|#


(defun string-similarity (ref-string shaky-string &optional (test #'achar=))
  "Calculate word similarity based on Levenshtein distance."
  (- 1 (float (/ (edit-distance:distance
                  (str:unwords (str:words ref-string))
                  (str:unwords (str:words shaky-string))
                  :test test)
                 (length ref-string)))))

(defparameter *string-similarity-threshold* 0.80)

(defun string~ (ref-string shaky-string &key (test #'achar=) (threshold *string-similarity-threshold*))
  "String similarity predicate."
  (>= (string-similarity ref-string shaky-string test)
      threshold))

(defun hudate->sql (hudate)
  "Convert HUDATE to SQL-formatted string."
  (apply #'format nil "~4,'0d-~2,'0d-~2,'0d" hudate))

(defun clean-str-sql (string)
  "Clean STRING and wrap it in 's."
  (str:ensure (clean-name string :capitalize nil) :wrapped-in "'"))


;;; ----------------------------------------------------------------------
;;; Database context


(defmacro with-db-context (&body body)
  "Create context where *DB* is connected to %DBFILE%, disconnected on exit when *AUTO-CLOSE* is true."
  `(with-open-database (*db* %dbfile% :busy-timeout *timeout*)
     ,@body))


(defun db-cleanup ()
  "Disconnect *DB*, should be called on exiting the program."
  (when (typep *db* 'sqlite-handle)
    (disconnect *db*)))


;;; ----------------------------------------------------------------------
;;; SQL statement text


(defun sql-name (arg)
  "Transform STRING so it can be a table/column name in the database."
  (let ((string (symbol->string arg)))
    (when string
      (let ((rewrites '(("á" "a") ("é" "e") ("í" "i") ("ó" "o") ("ö" "o")
                        ("õ" "o") ("ú" "u") ("ü" "u") ("û" "u")))
            (result   (astring-downcase (copy-seq string))))
        (loop for i from 0 below (length result)
              for c = (elt result i) doing
              (unless (or (alpha-achar-p c)
                          (digit-char-p c))
                (setf (elt result i) #\Space)))
        (dolist (pair rewrites)
          (setf result (str:replace-all (first pair) (second pair) result)))
        (str:replace-all " " "_"
                         (str:collapse-whitespaces 
                          (str:trim result)))))))


(defun existing-tables ()
  "List existing tables in DATABASE."
  (with-db-context 
    (apply #'nconc (execute-to-list *db*
     "SELECT name FROM sqlite_master WHERE type='table'"))))


(defparameter *temp-name* nil)

(defun unique-table-name (infix)
  "Create name containing INFIX that is not a name of any existing table in DATABASE."
  (or *temp-name*
      (let ((existing-tables (existing-tables)))
        (loop for name = (concatenate 'string "temp_" infix "_"
                                      (random-alphanumeric-string 6))
              while (member name existing-tables :test #'string=)
              finally return name))))


(defun join-clauses (table)
  "List SQL substatements for left joins of TABLE."
  (mapcar #'(lambda (record)
              (destructuring-bind (t-many t-one id-col)
                  record
                (format nil "LEFT JOIN ~a ON ~a.~a = ~a.~a"
                        t-one t-many id-col t-one id-col)))
          (many-joins table)))


(defun column-names (arg &optional (sql-names nil))
  "Parse a list of column names from ARG."
  (let ((list
         (typecase arg
           (list   arg)
           (string (str:words arg))
           (xarray (coerce (head arg) 'list))
           (vector (coerce arg 'list))
           (array  (loop for c from 0 below (array-dimension arg 1)
                         collecting (aref arg 0 c)))
           (t      (error "Cannot parse a list of column names from ~a." arg)))))
    (if sql-names
      (mapcar #'sql-name list)
      list)))


(defun septd (list &key (in-parens t))
  "Create substring with elements of LIST separated by a space."
  (let ((preproc (mapcar #'(lambda (element)
                                  (if (listp element)
                                    (septd element)
                                    element)) list))
        (open    (if in-parens "(" ""))
        (close   (if in-parens ")" "")))
    (format nil "~a~{~a~^ ~}~a" open preproc close)))


(defun sql-list (list &key (parens nil) (comma t))
  "Turn a list a strings, symbols or numbers into an SQL list:
  ('a b c' 'x y' '1 2 3') => '(a b c, x y, 1 2 3)'   "
  (assert (or (typep list 'seq-of-strings-symbols-or-numbers)
              (typep list 'seq-of-seqs))
      (list)
    "~a is not a sequence of sequences, strings, symbols or numbers." list)
  (let ((open   (if parens "(" ""))
        (close  (if parens ")" ""))
        (list2  (mapcar #'(lambda (element)
                            (if (listp element)
                              (septd element :in-parens nil)
                              element))
                        list)))
    (if comma
      (format nil "~a~{~a~^, ~}~a" open list2 close)
      (format nil "~a~{~a~^ ~}~a" open list2 close))))


;;; ----------------------------------------------------------------------
;;; Network pathnames


(defun network-drives ()
  "Return a list of Windows network drive connections as sublists (drive path)."
  (let* ((outstream (make-string-output-stream))
         (output    (progn (uiop:run-program "wmic path win32_mappedlogicaldisk get deviceid, providername" :output outstream)
                      (get-output-stream-string outstream)))
         (rows      (rest (str:split #\Newline output))))
    (mapcar #'(lambda (string)
                (let ((drive (subseq string 0 2))
                      (path  (str:trim (subseq string 2))))
                  (list drive path)))
            (remove-if #'(lambda (string)
                           (< (length string) 2))
                       rows))))


(defun resolve-network-filename (pathname)
  "If PATHNAME refers to a location on a network drive, replace the drive designation with the true network path."
  (let* ((namestring (namestring pathname))
         (drives     (network-drives))
         (result     namestring))
    (dolist (pair drives)
      (when (and (>= (length namestring) 2)
                 (string-equal (first pair) (subseq namestring 0 2)))
        (setf result (concatenate 'string (second pair) (subseq namestring 2)))))
    (pathname result)))
