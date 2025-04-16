;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*-


(in-package #:sig)


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


(defun select-table (table &optional (schema *schema*))
  "Get TABLE's sub-plist from SCHEMA."
  (find-if #'(lambda (record) (eq (getf record :table) table))
           (getf schema :tables)))


(defun select-column (column table &optional (schema *schema*))
  "Get COLUMN's sub-plist from TABLE's sub-plist from SCHEMA."
  (find-if #'(lambda (record) (eq (getf record :column) column))
           (getf (select-table table schema) :columns)))


(defun schema-tables (&optional (schema *schema*))
  "List names of all tables defines in SCHEMA."
  (mapcar #'(lambda (table) (getf table :table))
          (getf schema :tables)))


(defun schema-columns (table &optional (schema *schema*))
  "List names of columns in TABLE."
  (mapcar #'(lambda (column) (getf column :column))
          (getf (select-table table schema) :columns)))


(defun column-description (column table &optional (schema *schema*))
  "List keywords describing COLUMN in TABLE."
  (getf (select-column column table schema) :desc))


(defun many-joins (table &optional (schema *schema*))
  "List joins defined for many-table TABLE."
  (remove-if-not #'(lambda (record) (eq (first record) table))
                 (getf schema :connections)))


;;; ----------------------------------------------------------------------
;;; SQLite statement text


(defun sqlite-name (string)
  "Transform STRING so it can be a table/column name in the database."
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
                      (str:trim result)))))


(defun existing-tables (database)
  "List existing tables in DATABASE."
  (apply
   #'nconc (execute-to-list database "SELECT name FROM sqlite_master WHERE type='table'")))


(defun unique-table-name (database infix)
  "Create name containing INFIX that is not a name of any existing table in DATABASE."
  ;; Worker function, generates string containing random characters and INFIX.
  (flet ((worker (&optional (length 6))
           (let ((charlist (loop for i from 0 below length collecting
                                 (code-char (+ (random 23) 65)))))
             (concatenate 'string "temp_"  infix "_"
                          (coerce charlist 'string)))))
    ;; Names of existing tables.
    (let ((existing-tables (existing-tables database)))
      ;; Keep calling WORKER until a uniq name is found.
      (loop for name = (worker)
            while (member name existing-tables :test #'string=)
            finally return name))))


(defun join-clauses (table &optional (schema *schema*))
  "List SQL substatements for left joins of TABLE."
  (mapcar #'(lambda (record)
              (destructuring-bind (t-many t-one id-col)
                  record
                (format nil "LEFT JOIN ~a ON ~a.~a = ~a.~a"
                        t-one t-many id-col t-one id-col)))
          (many-joins table schema)))


#|
;;; ----------------------------------------------------------------------
;;; Excel support


(defun extract-sql-values (row)
  "Turn values in an xarray ROW into a list a strings."
  (loop for c from 0 below (xarray-width row)
        for v = (xcref row c)
        for d = (parse-hudate v)
        collecting
        (cond
         ((empty-cell-p v) "NULL")                          ; empty cells will become NULLs
         (d (apply #'format nil "~4,'0d-~2,'0d-~2,'0d" d))  ; dates will be formed as 2020-01-05
         (t (format nil "'~a'" v)))))                       ; everything esle will be a 'string'


(defun xarray-row->sql-values (row)
  "Turn values in an xarray ROW into a row of SQL values: ('val1', 2, 2023-03-03)."
  (format nil "(~{~a~^, ~})" (extract-sql-values row)))


(defun collect-xarray-rows-as-sql-values (xarray)
  "Turn XARRAY into a list of rows of SQL values."
  (let ((results '()))
    (do-xarows (row r xarray)
      (push (xarray-row->sql-values row) results))
    (nreverse results)))


(defun array->sql-values (xarray)
  "Turn XARRAY into a big string of rows of SQL values."
  (format nil "~{~a~^, ~}" (collect-xarray-rows-as-sql-values xarray)))
|#
