;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Basics


(defun resolve-table (table columns values)
  (let* ((tcols  (remove-if #'(lambda (column) (primary-key-p column table)) (schema-columns table)))
         (colres (mapcar #'(lambda (tcol)
                             (resolve-column tcol columns values))
                         tcols))
         (oks    (remove nil colres)))
    (when oks
      (append (list :table table) oks))))


(defun resolve-column (column columns values)
  (let* ((pos         (position column columns))
         (table       (first (table column :foreign-allowed t)))
         (immediate-p (immediate-p column table)))
    (if immediate-p
      (when pos
        (list :column column (nth pos values)))
      (let* ((foreign-table (second (find-if #'(lambda (row)
                                                 (eq column (third row)))
                                             (many-joins table))))
             (tabresult     (resolve-table foreign-table columns values)))
        (when tabresult
          (list :column column tabresult))))))


(defun resolve-statement (list)
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
        (push (if (consp val) (resolve-statement val) val)
              values)))
    ;; Making a statement
    (apply #'insert-into name columns t values)
    (first (first (select (list (primary-key name)) :from name :where (andeq columns values))))))


(defparameter *b3* '((VISELT_CSALADNEV "Wayne")
                     (VISELT_UTONEV_1 "Bruce")
                     (VISELT_UTONEV_2 "Diló")
                     (SZUL_CSALADNEV "Wayne")
                     (SZUL_UTONEV_1 "Bruce")
                     (SZUL_UTONEV_2 "Oki")
                     (ANYA_CSALADNEV "Wayne")
                     (ANYA_UTONEV_1 "Martha")
                     (ANYA_UTONEV_2 "Bruhuhu")
                     (ORSZAG "USA")
                     (VAROS "Gotham")
                     (SZUL_DATUMA "1939.04.01")
                     (IGAZOLVANYSZAM "AH128144")
                     (TANK_KOZPONT "Kelet-Gothami TK")
                     (SZERV_EGYS "Bûn sikátora Általános Iskola")
                     (BEOSZTAS "Tanársegéd")
                     (TELEFON "555-cipõ")
                     (EMAIL "bats@bat.cave")
                     (T_SOROZATSZAM "12345679")
                     (T_ERVENYESSEG_KEZDETE "2025-09-29")
                     (T_ERVENYESSEG_VEGE "2025-12-31")
                     (T_TIPUS "American Express")
                     (T_KAPCS_ESZKOZ "Mágnesszallag")
                     (T_ALLAPOT "Örökérvényû")
                     (T_VISSZAVONAS_DATUMA "9999-12-31")))


(defun testi ()
  (with-db-context
    (verify-statements (:execute nil)
      (let ((*sqlfn* #'sql->list))
        (resolve-statement
         (resolve-table 'igenylesek (mapcar #'first *b3*) (mapcar #'second *b3*)))))))


#|
 A legtöbb mezõt kötelezõ megadni, ezért pár mezõs hívásokkal esélytelen ezt tesztelni.
 
 |#
    


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


#|(defun resolve-values (table temp-columns temp-values)
  "Create hierarchical list of values to insert."
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
                    columns))))|#


(defun andeq (columns values)
  "WHERE clause where every column equals a given value."
  (let ((mains (mapcar #'(lambda (col val)
                           (list col '= val 'and))
                       columns values)))
    (butlast (apply #'nconc mains))))


#|(defun resolve-statement (list)
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
        (push (if (consp val) (resolve-statement val) val)
              values)))
    ;; Making a statement
;    (list :name name :subs subs :columns columns :values values)
    (apply #'insert-into name columns t values)
    (first (first (select (list (primary-key name)) :from name :where (andeq columns values))))
    ))|#


;; Rewrite this using the new RESOLVE-... functions!
(defun temp->fix (temp obj step)
  "Move data from TEMP into fix tables."
  (let ((temp-header (table-columns temp))
        (temp-rows   (dump-table temp))
        (root-table  (root-table)))
    (dolist (row temp-rows)
      (resolve-table
       (resolve-values root-table temp-header row))
      (dump obj "~a~%~%" row)
      (pstep obj :step step)
      (pabort obj))))


;;; ----------------------------------------------------------------------
;;; Single row insert / update


#|

  (let ((mapping (import-mapping 'tk)))
    (column-import 'anya_utonev_2 mapping)
    ...)

  |#



(defun insertdb (columns values)
  
  )


(defun updatedb (id columns values)
  
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
