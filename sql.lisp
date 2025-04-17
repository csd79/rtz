;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Base layer


(defparameter *no-ops* nil)


(defun statement (control-string &rest params)
  "Construct statement by interpolating PARAMS into CONTROL-STRING."
  (apply #'format nil control-string params))


(defun sql->list (db statement &optional (params nil))
  "Execute statement constructed from CONTROL-STRING and PARAMS on DB,
   return results as a list."
  (if *no-ops*
    statement
    (apply #'execute-to-list db statement params)))


(defun column-definition (column table &optional (schema *schema*))
  "Create column definition SQL substatement."
  (str:unwords
   (mapcar #'sql-name
           (nconc (list column) (column-description column table schema)))))


(defun all-column-definitions (table &optional (schema *schema*))
  "Create column definition SQL substatements for all columns of TABLE."
  (mapcar #'(lambda (column)
              (column-definition column table schema))
          (schema-columns table)))


(defun literal-column-defs (sequence)
  "Reform literal column definitions in SEQUENCE for SQL-LIST."
  (mapcar #'(lambda (list)
              (format nil "~{~a~^ ~}" list))
          (rmapcar #'sql-name sequence)))


(defun param-pattern (cols rows)
  "Create a pattern of SQL parameters."
  (let ((one-row (sql-list (loop for c from 0 below cols collecting "?") :row t)))
    (sql-list (loop for r from 0 below rows collecting one-row) :row nil)))


#|
(defun parse-sql-elements (list)
  "Convert a list of Lisp values into a list of SQL data that can be inserted into a statement."
  ;; 12                             =>  "12"                     integer
  ;; "str"                          =>  "'str'"                  string
  ;; :2024-01-01                    =>  "2024-01-01              date
  ;; column                         =>  "column"                 name
  ;; (12 "str" column)              =>  "(12, 'str', column)     list of values
  ;; (:lit id integer primary key)  =>  "id integer primary key"
  (mapcar #'(lambda (element)
              (typecase element
                (integer (format nil "~d" element))
                (string  (format nil "'~a'" element))
                (keyword (symbol-name element))
                (symbol  (symbol-name element))
                (list    (if (eq (first element) :lit)
                           (format nil "~{~a~^ ~}" (parse-sql-elements (rest element)))
                           (format nil "(~{~a~^, ~})" (parse-sql-elements element))))))
          list))
|#


;;; ----------------------------------------------------------------------
;;; Operations


(defun drop-table (db name)
  "Drop table NAME in DB."
;  (execute-to-list db (format nil "drop table ~a" name)))
  (sql->list db (statement "drop table ~a" name)))


(defun drop-all-tables (db)
  "Drop all tables in DB."
  (dolist (table (existing-tables db))
    (drop-table db table)))


(defun table-info (table db)
  "Return a list of columns descriptions for TABLE."
  (sql->list db (statement "pragma table_info(~a)" table)))


(defun table-columns (table db)
  "List the names of TABLE's columns."
  (mapcar #'second (table-info table db)))


(defun db-info (db)
  "Print the description of every table in DATABASE."
  (dolist (table (table-list db))
    (format t "~%~%~a  -------------------------------------~%~{~a~%~}"
            table (table-info table db))))


(defun dump-table (table db)
  "Return the complete contents of TABLE in the form of a list."
  (sql->list db (statement "select ~a from ~a"
                           (sql-list (table-columns table db) :row nil)
                           table)))


(defun number-of-rows (table db)
  "Return the number of rows in TABLE."
  (second (first
           (sql->list db (statement "select ~s, count(*) from ~a"
                                    (first (table-columns table db))
                                    table)))))


(defun create-table (db name &optional (cols-arg nil))
  "Create table NAME in DB."
  (let ((columns (typecase cols-arg
                   (seq-of-seqs-of-strings-or-symbols (literal-column-defs cols-arg))
                   (seq-of-strings-or-symbols         (column-names cols-arg))
                   (t                                 (all-column-definitions name)))))
    (if columns
      (sql->list db (statement "create table ~a ~a" name (sql-list columns :row t)))
      (error "Couldn't create table ~a: list of columns is empty." name))))


(defun insert-worker (db table dest values new-only)
  "Worker function helping INSERT-INTO and INSERT-NEW-INTO."
  (let* ((width  (if (sequencep dest) (length dest) 1))
         (length (length values))
         (height (round (/ length width)))
         (ignore (if new-only "OR IGNORE " "")))
    ;; If number of values doesn't correspond with number of columns => error.
    (unless (= length (* width height))
      (error "Numberof columns (~a) is in conflict with number of values (~a)." width length))
    ;; Operation.
    (sql->list db
               (statement "insert ~ainto ~a ~a values ~a" ignore table
                          ;; List of destination columns.
                          (sql-list (if (= width 1)
                                      (list dest)
                                      dest)
                                    :row t)
                          ;; Patern of ?s.
                          (param-pattern width height))
               values)))


(defun insert-into (db table dest &rest values)
  "Insert VALUES as new rows into COLUMNS of TABLE."
  (insert-worker db table dest values nil))


(defun insert-new-into (db table dest &rest values)
  "Insert only new VALUES as rows into COLUMNS of TABLE."
  (insert-worker db table dest values t))
