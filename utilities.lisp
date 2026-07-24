;;; -*- Msode: Common-Lisp; Author: denes.cselovszky@gmail.com -*-
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; General


#|(defun synonym= (thing-1 thing-2 synonyms &key (test #'astring=))
  "Compare 2 strings (or other things) using a synonyms dictionary."
  (let ((candidates (apply #'nconc (remove-if-not
                                    #'(lambda (row)
                                        (member thing-1 row :test test))
                                    synonyms))))
    (member thing-2 candidates :test test)))|#


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
