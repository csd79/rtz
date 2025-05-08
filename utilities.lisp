;;; -*- Msode: Common-Lisp; Author: denes.cselovszky@gmail.com -*-


(in-package #:sig)


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


;;; ----------------------------------------------------------------------
;;; Database context


(defmacro with-db-context (&body body)
  "Create context where *DB* is connected to %DBFILE%, disconnected on exit when *AUTO-CLOSE* is true."
  `(unwind-protect
       (progn
         (unless (typep *db* 'sqlite-handle)
           (setf *db* (connect %dbfile% :busy-timeout *timeout*)))
         ,@body)
     (when (and *auto-close*
                (typep *db* 'sqlite-handle))
       (disconnect *db*)
       (setf *db* nil))))


(defun db-cleanup ()
  "Disconnect *DB*, should be called on exiting the program."
  (when (typep *db* 'sqlite-handle)
    (disconnect *db*)))


;;; ----------------------------------------------------------------------
;;; Schema handling


(defun select-table (table)
  "Get TABLE's sub-plist from SCHEMA."
  (find-if #'(lambda (record) (eq (getf record :table) (string->symbol table)))
           (getf *schema* :tables)))


(defun select-column (column table)
  "Get COLUMN's sub-plist from TABLE's sub-plist from SCHEMA."
  (find-if #'(lambda (record) (eq (getf record :column) (string->symbol column)))
           (getf (select-table (string->symbol table)) :columns)))


(defun schema-tables ()
  "List names of all tables defines in SCHEMA."
  (mapcar #'(lambda (table) (getf table :table))
          (getf *schema* :tables)))


(defun schema-columns (table)
  "List names of columns in TABLE."
  (mapcar #'(lambda (column) (getf column :column))
          (getf (select-table table) :columns)))


(defun column-description (column table)
  "List keywords describing COLUMN in TABLE."
  (getf (select-column column table) :desc))


(defun column-import (column table)
  "Return temp table header to import value from."
  (getf (select-column column table) :import))


(defun many-joins (table)
  "List joins defined for many-table TABLE."
  (remove-if-not #'(lambda (record) (eq (first record) (string->symbol table)))
                 (getf *schema* :connections)))


(defun all-connections (accessor)
  "List all individual elements of the connection field."
  (remove-duplicates
   (mapcar accessor (getf *schema* :connections))))


(defun one-tables ()
  "List all 'one' tables from SCHEMA."
  (all-connections #'second))


(defun many-tables ()
  "List all 'many' tables from SCHEMA."
  (all-connections #'first))


(defun import-columns (table)
  "List all columns in TABLE that has an :IMPORT value in SCHEMA."
  (remove-if-not #'(lambda (column) (getf column :import))
                 (getf (select-table table) :columns)))


(defun foreign-columns (table)
  "List all columns in TABLE that doesn't have an :IMPORT value in SCHEMA."
  (remove-if #'(lambda (column)
                 (or (getf column :import)
                     (and (search '(primary key)
                                  (getf column :desc)))))
             (getf (select-table table) :columns)))


(defun immd-worker (column list)
  "Worker fn for IMMEDIATE-P and FOREIGN-P."
  (member column list :key #'(lambda (rec) (getf rec :column))))
  
(defun immediate-p (column table)
  "Does COLUMN have an :IMPORT key?"
  (immd-worker column (import-columns table)))

(defun foreign-p (column table)
  "Is COLUMN without an :IMPORT key?"
  (immd-worker column (foreign-columns table)))


(defun root-table ()
  "Return the name of the root table of *SCHEMA*."
  (getf *schema* :root))


(defun new-only-p (table)
  "Returns T if TABLE should contain unique records."
  (getf (select-table table) :new-only))


(defun primary-key-p (column table)
  "Returns T if COLUMN is TABLE's primary key."
  (search '(primary key)
          (getf (select-column column table) :desc)))


;;; ----------------------------------------------------------------------
;;; Types


(defun sequencep (value)
  "T if VALUE is of type sequence."
  (typep value 'sequence))


(defun seq-of-strings-p (value)
  "T if VALUE is a sequence of strings."
  (and value
       (sequencep value)
       (every #'identity (mapcar #'stringp (coerce value 'list)))))
(deftype seq-of-strings () '(satisfies seq-of-strings-p))


(defun seq-of-seqs-p (value)
  "T if VALUE is a sequence of sequences."
  (and value
       (sequencep value)
       (every #'identity (mapcar #'sequencep (coerce value 'list)))))
(deftype seq-of-seqs () '(satisfies seq-of-seqs-p))


(defun stringp-or-symbolp (value)
  "T if VALUE is either a string or a symbol."
  (or (stringp value)
      (symbolp value)))


(defun seq-of-strings-or-symbols-p (value)
  "T if VALUE is a sequence of strings or symbols."
  (and value
       (sequencep value)
       (every #'identity (mapcar #'stringp-or-symbolp
                                 (coerce value 'list)))))
(deftype seq-of-strings-or-symbols ()
  '(satisfies seq-of-strings-or-symbols-p))


(defun seq-of-strings-symbols-or-numbers-p (value)
  "T if VALUE is a sequence of strings, symbols or numbers."
  (and value
       (sequencep value)
       (every #'(lambda (element)
                  (or (stringp-or-symbolp element)
                      (numberp element)))
              (coerce value 'list))))
(deftype seq-of-strings-symbols-or-numbers ()
  '(satisfies seq-of-strings-symbols-or-numbers-p))


(defun seq-of-seqs-of-strings-or-symbols-p (value)
  "T if VALUE is a sequence of sequences of strings or symbols."
  (and value
       (sequencep value)
       (every #'identity (mapcar #'seq-of-strings-or-symbols-p
                                 (coerce value 'list)))))
(deftype seq-of-seqs-of-strings-or-symbols ()
  '(satisfies seq-of-seqs-of-strings-or-symbols-p))


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
  (apply #'nconc (execute-to-list *db* "SELECT name FROM sqlite_master WHERE type='table'")))


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


(defun column-names (arg)
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
    (mapcar #'sql-name list)))


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
        (/list  (mapcar #'(lambda (element)
                            (if (listp element)
                              (septd element :in-parens nil)
                              element))
                        list)))
    (if comma
      (format nil "~a~{~a~^, ~}~a" open /list close)
      (format nil "~a~{~a~^ ~}~a" open /list close))))


;;; ----------------------------------------------------------------------
;;; Excel support


(defun get-xarray (excel-file)
  "Return XARRAY containing the first sheet of EXCEL-FILE."
  (with-property-accessors
    (setf (property-accessors-on) t)
    (let ((xarray (with-workbook (:open excel-file :read-only t :wsvars (wsheet) :close t)
                    (read-xarray (used-range wsheet)))))
      (setf (property-accessors-on) nil)
      xarray)))


(defun xlval->sql (value)
  "Transform VALUE read from Excel for inserting into SQL."
  (let ((date (parse-hudate value)))
    (cond
     ((empty-cell-p value) "NULL")                            ; empty cells will become NULLs
     (date (apply #'format nil "~4,'0d-~2,'0d-~2,'0d" date))  ; dates will be formed as 2020-01-05
     (t value))))                                             ; everything esle will pass as-is
