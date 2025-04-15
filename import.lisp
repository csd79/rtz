;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Extract & reform Excel values


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


;;; ----------------------------------------------------------------------
;;; Importing


#|(defun single-xlsx->new-temp (db-file excel-file infix &optional (max-rows 10))
  "Import contents of EXCEL-FILE into new temp table in DB-FILE, return name of temp table."
  (with-property-accessors
    (setf (property-accessors-on) t)
    ;; Reading contents of EXCEL-FILE
    (let ((xarray (with-workbook (:open excel-file :read-only t :wsvars (wsheet) :close t)
                    (read-xarray (used-range wsheet)))))
      (setf (property-accessors-on) nil)

      (with-open-database (db db-file :busy-timeout *timeout*)
        ;; 
        (let* ((curr-temps (table-list db))
               (temp-table (new-temp-name curr-temps infix))
               (tt-key     (intern (string-upcase temp-table) "KEYWORD"))
               (columns    (format nil "(~{~a~^, ~})" (mapcar #'sqlite-name (coerce (msoffice::head xarray) 'list))))
               (height      (xarray-actual-height xarray)))
          ;; Creating tempt table with columns from xarray header
          (execute-non-query
           db (format nil "create table ~a ~a" tt-key columns))
          ;; Insert row groups
          (loop for g from 0 below height by max-rows
                for s = (loop for i from g upto (min (1- height) (+ g max-rows)) collecting i)
                for rows = (xarows xarray (coerce s 'vector)) doing
#|                (execute-non-query
                 db (format nil "insert into ~a ~a values ~a~%~%~%~%"
                            temp-table columns (array->sql-values rows))))|#
                (sql db "insert into ~a ~a values ~a"
                     temp-table columns (array->sql-values rows)))
          ;; Return name of temp table
          temp-table)))))|#
(defun single-xlsx->new-temp (db excel-file infix &optional (max-rows 10))
  "Import contents of EXCEL-FILE into new temp table in DB, return name of temp table."
  (with-property-accessors
    (setf (property-accessors-on) t)
    ;; Reading contents of EXCEL-FILE
    (let* ((xarray     (with-workbook (:open excel-file :read-only t :wsvars (wsheet) :close t)
                         (read-xarray (used-range wsheet))))
           (currents   (table-list db))
           (temp-table (new-temp-name currents infix))
           (tt-key     (intern (string-upcase temp-table) "KEYWORD"))
           (columns    (format nil "(~{~a~^, ~})" (mapcar #'sqlite-name (coerce (msoffice::head xarray) 'list))))
           (height     (xarray-actual-height xarray)))
      (setf (property-accessors-on) nil)
      ;; Creating tempt table with columns from xarray header
      (execute-non-query
       db (format nil "create table ~a ~a" tt-key columns))
      ;; Insert row groups
      (loop for g from 0 below height by max-rows
            for s = (loop for i from g upto (min (1- height) (+ g max-rows)) collecting i)
            for rows = (xarows xarray (coerce s 'vector)) doing
            (sql db "insert into ~a ~a values ~a"
                 temp-table columns (array->sql-values rows)))
      ;; Return name of temp table
      temp-table)))
