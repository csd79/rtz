;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Utilities


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

(defun new-temp-name (existing infix)
  "Create a name using INFIX that is not a member of EXISTING names."
  ;; MIGHT LOOP FOREVER!
  (flet ((worker (&optional (length 6))
           (let ((charlist (loop for i from 0 below length collecting
                                 (code-char (+ (random 23) 65)))))
             (concatenate 'string "temp_"  infix "_"
                          (coerce charlist 'string)))))
    (loop for name = (worker)
          while (member name existing :test #'string=)
          finally return name)))


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

(defun table-list (database)
  "List tables in DATABASE."
  (apply #'nconc 
         (sql database "SELECT name FROM sqlite_master WHERE type='table'")))
