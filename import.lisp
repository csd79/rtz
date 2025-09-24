;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; xarray -> temp




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
  (let* ((end     (min height (+ start *rows-per-statement*)))
         (indices (loop for i from start below end collecting i)))
    (xarows xarray (coerce indices 'vector))))


(defun import-xarray (table obj key step)
  "Go over rows of the source in OBJ by groups, import them into TABLE."
  (let* ((xarray (source-data obj key))
         (height (xarray-indexed-height xarray)))
    (loop for start from 0 below height by *rows-per-statement*
          for rows    = (group-rows xarray start height)
          for height2 = (xarray-indexed-height rows)
          for vals    = (collect-row-values rows)
          doing (apply #'insert-into table (column-names xarray) nil vals)
                (dump obj "Sorok: ~a - ~a~%" start (+ start height2 -1))
                (pstep obj :step (* step *rows-per-statement*))
                (pabort obj)
                )))


;;; ----------------------------------------------------------------------
;;; temp -> fix (auto-resolve insertion)


(defun resolve-values (table temp-columns temp-values)
  "Create hierarchical list of values to insert."
;  (wg-msg "~a" temp-columns)
  (let ((columns (remove-if #'(lambda (column) (primary-key-p column table)) (schema-columns table))))
    (append (list :table table)
            (mapcar #'(lambda (column)
                        (if (immediate-p column table)
                          ;; COLUMN contains an immediate value
                          (let* ((from (sql-name (column-import column table)))
                                 ;; Find value by it's import header's position in TEMP-COLUMNS
                                 (pos  (position from temp-columns :test #'string=)))
                            (list :column column (nth pos temp-values)))
                          ;; COLUMN contains a foreign value
                          (let* ((many-joins (many-joins table))
                                 ;; Find table for foreign index
                                 (foreign-table (second (find-if #'(lambda (row)
                                                                     (eq column (third row)))
                                                                 many-joins))))
                            ;; Create sublist for FOREIGN-TABLE
                            (list :column column
                                  (resolve-values foreign-table temp-columns temp-values)))))
                    columns))))
#|(defun resolve-values (table temp-columns temp-values)
  "Create hierarchical list of values to insert."
  (let ((columns (remove-if #'(lambda (column) (primary-key-p column table)) (schema-columns table))))
    (append (list :table table)
;            (remove nil
                    (mapcar #'(lambda (column)
                                (let ((import-column (sql-name (column-import column table))))
;                                (let ((import-column (column-import column table)))
                                  (wg-msg "~a     ~a     ~a" import-column (type-of import-column) temp-columns)
                                  (when (member import-column temp-columns :test #'string=)
                                    (wg-msg "YEAAAAHHHHHH!!!!        ~a" import-column)
                                    (if (immediate-p column table)
                                      ;; COLUMN contains an immediate value
                                      (let* ((from (sql-name import-column))
                                             ;; Find value by it's import header's position in TEMP-COLUMNS
                                             (pos  (position from temp-columns :test #'string=)))
                                        (list :column column (nth pos temp-values)))
                                      ;; COLUMN contains a foreign value
                                      (let* ((many-joins (many-joins table))
                                             ;; Find table for foreign index
                                             (foreign-table (second (find-if #'(lambda (row)
                                                                                 (eq column (third row)))
                                                                             many-joins))))
                                        ;; Create sublist for FOREIGN-TABLE
                                        (list :column column
                                              (resolve-values foreign-table temp-columns temp-values)))))))
                            columns))));)|#


(defun andeq (columns values)
  "WHERE clause where every column equals a given value."
  (let ((mains (mapcar #'(lambda (col val)
                           (list col '= val 'and))
                       columns values)))
    (butlast (apply #'nconc mains))))


(defun resolve-table (list)
  "Insert values into tables."
  (let ((name    (second list))
        (subs    (cddr list))
        (columns '())
        (values  '()))
    ;; Collecting column names and values
    (dolist (row subs)
      (let ((col (second row))
            (val (third row)))
        (push col columns)
        ;; If value is a sublist, resolve that first
        (push (if (consp val) (resolve-table val) val)
              values)))
    ;; Making a statement
    (apply #'insert-into name columns t values)
    (first (first (select (list (primary-key name)) :from name :where (andeq columns values))))))


(defun temp->fix (temp obj step)
  "Move data from TEMP into fix tables."
  (let ((temp-header (table-columns temp))
        (temp-rows   (dump-table temp))
        (root-table  (root-table)))
;    (loop for row across temp-rows doing
    (dolist (row temp-rows)
      (resolve-table
       (resolve-values root-table temp-header row))
      (dump obj "~a~%~%" row)
      (pstep obj :step step)
      (pabort obj)
      )))


;;; ----------------------------------------------------------------------
;;; Single row insert / update


(defun auto-insert (columns values &key (id nil id-provided-p))
  )


;;; ----------------------------------------------------------------------
;;; Operations


(defun import-xlsxs (obj)
  "Import XLSX files into DB."
  (wax::with-progress-new ("Importálás Excel fájlból" obj)
    ;; Load all data sources, sum their number of lines
    (dump obj "Sorok számlálása...~%~%")
    (let* ((rows (loop for (key) on (data-sources obj) by #'cddr
                       doing   (load-data-source obj key)
                       summing (xarray-indexed-height (source-data obj key))
                       doing   (wax::purge-data-source obj key)))
           (step-import 1)
           (step-fix (* step-import 6))
           (*sqlfn* #'sql->list))
      ;; Setf progress limit according to number of lines
      (setf (pstep-limit obj) (* rows (+ step-import step-fix)))
      ;; Import each data source via separate temp tables:
      ;;   load source, create temp table, migrate data to fixed tables,
      ;;   delete temp table & data source
      (loop for (key) on (data-sources obj) by #'cddr
            for temp = (unique-table-name (user-token))
            doing (dump obj "Fájl betöltése átmeneti táblába: ~a~%~%"
                        (source-filename obj key))
                  (load-data-source obj key)
                  (create-table temp (column-names (source-data obj key)))
                  (import-xarray temp obj key step-import)
                  (dump obj "~%Adatok véglegesítése...~%~%")
                  (temp->fix temp obj step-fix)
                  (drop-table temp)
                  (wax::purge-data-source obj key)))))
