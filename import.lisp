;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Importing


(defparameter *rows-per-statement* 10)


(defun collect-row-values (rows)
  "Collect values stored in ROWS into a list in row-major order."
  (let ((accum '())
        (width (xarray-width rows)))
    (do-xarows (row r rows)
      (push (loop for c from 0 below width collecting (xlval->sql (xcref row c)))
            accum))
    (apply #'nconc (nreverse accum))))


(defun group-rows (xarray start height)
  "Xarray rows of one group starting from row START."
  (let* ((end     (min (1- height) (+ start *rows-per-statement*)))
         (indices (loop for i from start upto end collecting i)))
    (xarows xarray (coerce indices 'vector))))


(defun import-xarray (db table xarray)
  "Go over rows of XARRAY by groups, import them into TABLE."
  (let ((height (xarray-indexed-height xarray)))
    (wax::with-progress ("Excel importálás" abort dump move height)
      (loop for start from 0 below height by *rows-per-statement*
            for rows  = (group-rows xarray start height)
            for step  = (xarray-indexed-height rows)
            for vals  = (collect-row-values rows)
            doing (apply #'insert-into db table (column-names xarray) vals)
                  (dump "Sorok: ~a - ~a~%" start (+ start step))
                  (move :step step)
                  (abort)))))


(defun import-xlsx (db xlsx infix)
  "Import XLSX into a new temp table in DB."
  (let ((xarray (get-xarray xlsx))
        (temp   (unique-table-name db infix)))
    (create-table db temp (column-names xarray))
    (import-xarray db temp xarray)
    temp
    ;;;; It át kéne pakolni az importált adatokat a normalizált táblákba
    ))
