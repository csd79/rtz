;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Base layer


;;; :EXECUTE              : execute SQL statements
;;; :EXECUTE-AND-VERIFY   : execute SQL statements, dump the statements and results
;;; :VERIFYY              : dump statements without executing them
(defparameter *exec/verify* :execute)

(defparameter *statements-out* nil)

(defmacro verify-statements ((&key (execute t)) &body body)
  `(let ((*statements-out* (make-string-output-stream))
         (*exec/verify*    (if ,execute :execute-and-verify :verify)))
     ,@body
     (get-output-stream-string *statements-out*)))


(defun statement (control-string &rest params)
  "Construct statement by interpolating PARAMS into CONTROL-STRING."
  (apply #'format nil control-string params))


(defun sql->list (statement &optional (params nil))
  "Execute statement constructed from CONTROL-STRING and PARAMS,
   return results as a list."
  (let ((result (when (member *exec/verify* '(:execute :execute-and-verify))
                  (apply #'execute-to-list *db* statement params))))
    (when *statements-out*
      (format *statements-out*
              "~a~%~a~%~a~%~%~%"
              statement
              params
              result))
    result))


(defun column-definition (column table)
  "Create column definition SQL substatement."
  (str:unwords
   (mapcar #'sql-name
           (nconc (list column) (column-description column table)))))


(defun all-column-definitions (table)
  "Create column definition SQL substatements for all columns of TABLE."
  (mapcar #'(lambda (column)
              (column-definition column table))
          (schema-columns table)))


#|(defun literal-column-defs (sequence)
  "Reform literal column definitions in SEQUENCE for SQL-LIST."
  (mapcar #'(lambda (list)
              (format nil "~{~a~^ ~}" list))
          (rmapcar #'sql-name sequence)))|#
(defun literal-column-defs (sequence)
  "Reform literal column definitions in SEQUENCE for SQL-LIST."
  (mapcar #'(lambda (element)
              (cond ((or (stringp element)
                         (symbolp element))
                     element)
                    ((sequencep element)
                     (format nil "~{~a~^ ~}" (coerce element 'list)))
                    (t nil)))
          (rmapcar #'sql-name sequence)))


(defun param-pattern (cols rows)
  "Create a pattern of SQL parameters."
  (let ((one-row (sql-list (loop for c from 0 below cols collecting "?") :parens t)))
    (sql-list (loop for r from 0 below rows collecting one-row) :parens nil)))


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
;;; Clauses


(defun col (column &optional table)
  "Create subclause 'TABLE.COLUMN'."
  (let ((table (if table (format nil "~a." (sql-name table)) "")))
    (intern (string-upcase 
             (format nil "~a~a" table (sql-name column))))))
#|(defmacro colmn (table column)
  "Create sub-clause 'TABLE.COLUMN'."
  `(format nil "~a.~a" (sql-name ',table) (sql-name ',column)))|#


(defun type-rewrites (list)
  "Transform elements of LIST as printed SQL values."
  (mapcar #'(lambda (element)
              (typecase element
;                (list (type-rewrites element))
                (list (cond ((eq (first element) :vals)
                             (sql-list (rest element) :parens t))
                            ((eq (first element) :@vals)
                             (sql-list (rest element) :parens nil))
                            (t (type-rewrites element))))
#|                 (if (eq (first element) :vals)
                        (sql-list (rest element) :parens t)
                        (type-rewrites element)))|#
;                (symbol (str:replace-all "-" " " (symbol-name element)))
;                (keyword (str:replace-all "-" "_" (symbol-name element)))
                (symbol (symbol-name element))
                (string (format nil "'~a'" element))
                (t element)))
          list))


(defun clause (name list)
  "General worker for generating clauses."
#|  (format nil "~{~a~^ ~}"
          (nconc (list (str:replace-all "-" " " (symbol-name name)))
                 list)))|#
#|  (septd (nconc (list (str:replace-all "-" " " (symbol-name name)))
                list)))|#
  (let ((name-string (typecase name
                       (list (septd name :in-parens nil))
                       (symbol (symbol-name name))
                       (string name)
                       (t (error "'~a' is not a usable clause name." name)))))
    (septd (nconc (list (str:replace-all "-" " " name-string))
                  (type-rewrites list))
           :in-parens nil)))


(defun clause-from (table)
  "Generate FROM clause."
  (clause :from (list table)))


(defun clause-left-join (table-many table-one column-many &optional (column-one nil))
  "Generate LEFT JOIN clause."
  (clause :left-join (list table-one 'on (colmn table-many column-many) '=
                           (colmn table-one (or column-one column-many)))))


(defun clause-where (filter-list)
  "Generate WHERE clause."
#|  (clause :where (mapcar #'(lambda (element)
                             (typecase element
                               (list (septd element :in-parens t))
                               (string (format nil "'~a'" element))
                               (t element)))
                         filter-list)))|#
  (clause :where filter-list))


(defun clause-order-by (columns)
  "Generate ORDER BY clause."
;  (let ((/columns (if (listp columns) columns (list columns))))
  (let ((/columns (if (listp columns) columns (list columns))))
    (clause :order-by /columns)))


(defun clause-group-by (column)
  "Generate GROUP BY clause."
  (clause :group-by (list column)))


(defun clause-having (filter-list)
  "Generate HAVING clause."
  (clause :having filter-list))


;;; ----------------------------------------------------------------------
;;; Operations


(defun drop-table (name)
  "Drop table NAME in *DB*."
;  (execute-to-list db (format nil "drop table ~a" name)))
  (sql->list (statement "drop table ~a" name)))


(defun drop-all-tables ()
  "Drop all tables in *DB*."
  (dolist (table (existing-tables))
    (drop-table table)))


(defun table-info (table)
  "Return a list of columns descriptions for TABLE."
  (sql->list (statement "pragma table_info(~a)" table)))


(defun table-columns (table)
  "List the names of TABLE's columns."
  (mapcar #'second (table-info table)))


(defun db-info ()
  "Print the description of every table in DATABASE."
  (dolist (table (existing-tables))
    (format t "~%~%~a  -------------------------------------~%~{~a~%~}"
            table (table-info table))))


(defun dump-table (table)
  "Return the complete contents of TABLE in the form of a list."
  (let ((columns (table-columns table)))
    (if columns
      (sql->list (statement "select ~a from ~a"
                            (sql-list columns :parens nil)
                            table))
      (error "Table not found in db: ~a." table))))


(defun number-of-rows (table)
  "Return the number of rows in TABLE."
  (second (first (sql->list (statement "select ~s, count(*) from ~a"
                                       (first (table-columns table))
                                       table)))))


(defun create-table (name &optional (cols-arg nil))
  "Create table NAME in DB."
  (let ((columns (typecase cols-arg
                   (seq-of-seqs-of-strings-or-symbols (literal-column-defs cols-arg))
                   (seq-of-strings-or-symbols         (column-names cols-arg))
                   (t                                 (all-column-definitions name)))))
    (if columns
      (sql->list (statement "create table ~a ~a" name (sql-list columns :parens t)))
      (error "Couldn't create table ~a: list of columns is empty." name))))


(defun insert-into (table dest new-only &rest values)
  "Insert VALUES into COLUMNS of TABLE."
  (let* ((width  (if (sequencep dest) (length dest) 1))
         (length (length values))
         (height (round (/ length width)))
         (ignore (if new-only "OR IGNORE " "")))
    ;; If number of values doesn't correspond with number of columns => error.
    (unless (= length (* width height))
      (error "Numberof columns (~a) is in conflict with number of values (~a)." width length))
    ;; Operation.
    (sql->list (statement "insert ~ainto ~a ~a values ~a" ignore table
                          ;; List of destination columns.
                          (sql-list (if (= width 1)
                                      (list dest)
                                      dest)
                                    :parens t)
                          ;; Patern of ?s.
                          (param-pattern width height))
               values)))
;               ))


#|(defun insert-into (db table dest &rest values)
  "Insert VALUES as new rows into COLUMNS of TABLE."
  (insert-worker db table dest values nil))


(defun insert-new-into (db table dest &rest values)
  "Insert only new VALUES as rows into COLUMNS of TABLE."
  (insert-worker db table dest values t))|#


(defun select (column-list &key (distinct nil) (from nil) (left-join nil) (where nil)
                                (order-by nil) (group-by nil) (having nil) (inserts '()))
  "Select rows."
  (let* ((/distinct  (if distinct "distinct" ""))
         (/columns   (sql-list column-list))
         (/from      (if from (clause-from from) ""))
         (/left-join (if left-join (apply #'clause-left-join from left-join) ""))
         (/where     (if where (clause-where where) ""))
         (/order-by  (if order-by (clause-order-by order-by) ""))
         (/group-by  (if group-by (clause-group-by group-by) ""))
         (/having    (if having (clause-having having) ""))
         (statement  (str:unwords (str:words
                       (statement "select ~a ~a ~a ~a ~a ~a ~a ~a"
                                  /distinct /columns /from /left-join
                                  /where /order-by /group-by /having)))))
    (sql->list statement inserts)))
;    statement))
#|    (list :from /from
          :left-join /left-join
          :where /where
          :order-by /order-by
          :group-by /group-by
          :having /having)))|#
