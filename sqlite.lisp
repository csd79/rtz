;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


#|
;;; ----------------------------------------------------------------------
;;; Base layer


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


(defun sql (database control-string &rest elements)
  "Execute statement on DATABASE interpolating ELEMENTS into CONTROL-STRING."
  (let ((statement (apply #'format nil control-string
                          (parse-sql-elements elements))))
    (execute-to-list database statement)))
;    statement))


;;; ----------------------------------------------------------------------
;;; Operations


(defun create-table (db table-name &rest column-descriptions)
  "Create new table TABLE_NAME in DB."
  (apply #'sql db "create table ~a ~a"
         table-name column-descriptions))


(defun insert-into (db table-name destinations &rest values)
  "Insert values into TABLE.NAME."
  (apply #'sql db "insert into ~a ~a values ~a"
         table-name destinations values))


;(defun select-from (db table-name &rest table-and-columns)
;  (apply #'sql db "select


(defun table-info (table database)
  "Return a list of columns descriptions for TABLE."
;  (sql database "SELECT sql FROM sqlite_schema WHERE name = '~a'" table))
  (sql database "pragma table_info(~a)" table))


(defun db-info (database)
  "Print the description of every table in DATABASE."
  (dolist (table (table-list database))
    (format t "~%~%~a  -------------------------------------~%~{~a~%~}"
            table (table-info table database))))

(defun dump-table (table database)
  "Return a list of all records in TABLE."
  (sql database "select ~a from ~a"
       (mapcar #'second (table-info table database))
       table))
|#
