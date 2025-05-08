;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; xarray -> temp


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


(defun import-xarray (table xarray)
  "Go over rows of XARRAY by groups, import them into TABLE."
  (let ((height (xarray-indexed-height xarray)))
    (wax::with-progress ("Excel importálás" abort dump move height)
      (loop for start from 0 below height by *rows-per-statement*
            for rows  = (group-rows xarray start height)
            for step  = (xarray-indexed-height rows)
            for vals  = (collect-row-values rows)
            doing (apply #'insert-into table (column-names xarray) nil vals)
                  (dump "Sorok: ~a - ~a~%" start (+ start step))
                  (move :step step)
                  (abort)))))


;;; ----------------------------------------------------------------------
;;; temp -> fix (auto-resolve insertion)


(defun resolve-immediate (t-column table v-columns values)
  "Return VALUE corresponding to T-COLUMN's :IMPORT header."
  (let* ((i-column (string (sql-name (column-import t-column table))))
         (position (position-if #'(lambda (element)
                                    (string-equal i-column (sql-name element)))
                                v-columns)))
    (if position
      (nth position values)
      'import-not-found)))


(defun resolve-foreign (table t-column v-columns values)
  "Insert foreign VALUE into corresponding table, return it's index."
  (let ((foreign-desc (find-if #'(lambda (element)
                                   (and (eq (first element) table)
                                        (eq (third element) t-column)))
                               (many-joins table))))
    (if foreign-desc
      (resolve-insert (second foreign-desc) values v-columns)
      'foreign-not-found)))


(defun insert-values-into (table values)
  "Insert VALUES into a new row in TABLE's columns (except primary key)."
  (let ((target-columns (remove-if #'(lambda (column)
                                       (primary-key-p column table))
                                   (schema-columns table)))
        (new-only       (new-only-p table)))
    (apply #'insert-into table target-columns new-only values)))


(defun resolve-insert (table values v-headers)
  "Insert VALUES into TABLE; trickle foreign values down into their respective tables; should be called with root table."
  (let ((t-headers (schema-columns table)))
    (insert-values-into table
     (mapcar #'(lambda (t-header)
                 (cond ((immediate-p t-header table)
                        (resolve-immediate t-header table v-headers values))
                       ((foreign-p t-header table)
                        (resolve-foreign table t-header v-headers values))
                       (t 'possibly-primery-key)))
             t-headers))))


;;; ----------------------------------------------------------------------
;;; Operations


(defun import-xlsx (xlsx infix)
  "Import XLSX into a new temp table in DB."
  (let ((xarray (get-xarray xlsx))
        (temp   (unique-table-name infix)))
    (create-table temp (column-names xarray))
    (import-xarray temp xarray)
    (print temp)
    ;;;; It át kéne pakolni az importált adatokat a normalizált táblákba
;    (resolve-insert (root-table) 
    ))
