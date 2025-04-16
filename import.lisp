;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


#|
;;; ----------------------------------------------------------------------
;;; Importing


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
|#