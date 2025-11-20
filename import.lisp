;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; Basics


(defun resolve-column (column columns values)
  "Helper for RESOLVE-TABLE, constructs subtree for COLUMN."
  ;; POS: is there a value for COLUMN provided in VALUES?
  ;; TABLE: the one that has COLUMN as a foreign key
  (let ((pos   (position column columns))
        (table (first (table column :foreign-allowed t))))
    ;; If COLUMN is an immediate value & not a key:
    ;; => (:COLUMN <collumn> <val>) when value is provided
    (if (immediate-p column table)
      (when pos `(:column ,column ,(nth pos values)))
      ;; If COLUMN isn't immediate:
      ;; => (:COLUMN <column> (:TABLE <subtree...>)) when subtree
      (let ((result (resolve-table (foreign-table table column)
                                   columns values)))
        (when result `(:column ,column ,result))))))


(defun resolve-table (table columns values)
  "Construct a tree that describes columns and their values, plus
   their links across tables. RESOLVE-INSERT-NEW will perform
   insert-calls guided by this tree. Example:
     (:TABLE IGENYLESEK
       (:COLUMN SZEMELY_ID     ; foreign key linking IGENYLESEK & SZEMELYEK
         (:TABLE SZEMELYEK     ; inside SZEMELYEK, some immediate values:
           (:COLUMN VISELT_CSALADNEV 'Wayne')
           (:COLUMN VISELT_UTONEV_1 'Bruce') ...)) ...)"
  ;; For every column in TABLE except the primary key:
  ;; make a list of column subtrees.
  (let ((subtrees (loop for current in (schema-columns table)
                        for subtree = (unless (primary-key-p current table)
                                        (resolve-column current columns values))
                        when subtree collect subtree)))
    ;; => (:TABLE <table> <subtrees...>)  or  NIL if there were no subtrees.
    (when subtrees `(:table ,table ,@subtrees))))


(defun where= (columns values)
  "WHERE clause where every COLUMNS equal VALUES one by one."
  (let ((mains (mapcar #'(lambda (col val) (list col '= val 'and))
                       columns values)))
    (butlast (apply #'nconc mains))))


(defun resolve-op (tree op &optional (test nil))
  "Insert values into tables. The guiding TREE must be generated
   using RESOLVE-TABLE."
  (flet ((body ()
           (let ((table (second tree)))
             ;; For each column:
             ;; - If value is a subtree, resolve it first
             ;; - Then collect names and values
             ;; - Finally, insert row into TABLE & return the new row ID
             (loop for row in (cddr tree)
                   for exp = (third row)
                   for val = (if (consp exp) (resolve-op exp op test) exp)
                   collecting (second row) into columns
                   collecting val into values
                   finally (return (funcall op table columns values))))))
    (if test
      (when (funcall test tree) (body))
      (body))))
    

(defparameter *b1* '((VISELT_CSALADNEV "Wayne")
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
                     (TANK_KOZPONT "Kelet-Gothami  TK")
                     (SZERV_EGYS "Bûn sikátora Általános Iskola")
                     (BEOSZTAS "Tanársegéd")
                     (TELEFON "555-cipõ")
                     (EMAIL "bats@bat.cave")
                     (T_SOROZATSZAM "12345679")
;                     (T_SOROZATSZAM "11223344")
                     (T_ERVENYESSEG_KEZDETE "2025-09-29")
                     (T_ERVENYESSEG_VEGE "2025-12-31")
                     (T_TIPUS "American Express")
                     (T_KAPCS_ESZKOZ "Mágnesszallag")
                     (T_ALLAPOT "Örökérvényû")
                     (T_VISSZAVONAS_DATUMA "9999-12-31")))


(defparameter *b2* '((VISELT_CSALADNEV "Kent")
                     (VISELT_UTONEV_1 "Clark")
                     (VISELT_UTONEV_2 "W")
                     (SZUL_CSALADNEV "El")
                     (SZUL_UTONEV_1 "Kal")
                     (SZUL_UTONEV_2 "Dee")
                     (ANYA_CSALADNEV "Lor-Van")
                     (ANYA_UTONEV_1 "Lara")
                     (ANYA_UTONEV_2 "Nartha")
                     (ORSZAG "USK")
                     (VAROS "Kriptoville")
                     (SZUL_DATUMA "4939.04.01")
                     (IGAZOLVANYSZAM "XXYYXXYY21")
                     (TANK_KOZPONT "Kansas  Southern Dustbowl")
                     (SZERV_EGYS "Smallville High")
                     (BEOSZTAS "Iskolaújság szerkesztõ")
                     (TELEFON "888-naci")
                     (EMAIL "sup@fort.soli")
                     (T_SOROZATSZAM "9876543210")
;                     (T_SOROZATSZAM "99887766")
                     (T_ERVENYESSEG_KEZDETE "2025-07-29")
                     (T_ERVENYESSEG_VEGE "2025-12-31")
                     (T_TIPUS "GHVC")
                     (T_KAPCS_ESZKOZ "Kristály")
                     (T_ALLAPOT "Megújuló")
                     (T_VISSZAVONAS_DATUMA "9999-12-31")))


(defparameter *b3* '((VISELT_CSALADNEV "Allen")
                     (VISELT_UTONEV_1 "Barry")
                     (VISELT_UTONEV_2 "X.")))


(defun gui-op-context (list op-fn &optional (test-fn nil))
  "Mid layer between the RESOLVE-fns and OP-FN."
  (with-db-context
    (let ((*sqlfn* #'sql->list)
          (cols    (mapcar #'first list))
          (vals    (mapcar #'second list)))
      (resolve-op
       (resolve-table (root-table) cols vals)
       op-fn test-fn))))


(defun select-same (table cols vals)
  (select (list (primary-key table))
          :from table :where (where= cols vals)))


(defun gui-insert-new (list)
  (gui-op-context list
   ;; Op function
   #'(lambda (table columns values)
       (apply #'insert-into table columns t values)
#|       (caar (select (list (primary-key table))
                     :from table :where
                     (where= columns values))))|#
       (caar (select-same table columns values)))
   ;; Test function
   #'(lambda (tree)
       (destructuring-bind (key table &rest rest) tree
         (declare (ignore rest))
         (if (and (eq key :table) (eq table (root-table)))
           ;; If current table is the root, further examination is needed
           (loop for e in (cddr tree)
                 for third = (third e)
                 when (atom third)
                 collect (second e) into cols and
                 collect third into vals
                 ;; If provided values exist in root table, cancel
#|                 finally (return (null (select (list (primary-key table))
                                               :from table :where
                                               (where= cols vals)))))|#
                 finally (return (null (select-same table cols vals))))
           ;; Otherwise, carry on with the resolve
           t)))))


(defun gui-update (ids list)
  (gui-op-context list
   #'(lambda (table columns values)
       ;; Op fn will be called on parent tables without updateable
       ;; columns, hence we have to check if VALUES are not NILs.
       (let ((values* (remove nil values))
             (ids*    (remove nil ids)))
         (when (and values* ids*)
           (apply #'update-rows table (primary-key table) ids*
                  columns values*))))))


(defun insert-update-test ()
  (with-transl (*rtz-translators*)
    (verify-statements (:execute t)
      (let ((ids (mapcar #'gui-insert-new (list *b1* *b2*))))
;        (gui-update (mapcar #'first ids) *b3*))))
        (gui-update ids *b3*)
      ))))

(defun resolve-table-test (list)
  (with-db-context
    (let ((*sqlfn* #'sql->list)
          (labels  (mapcar #'first list))
          (values  (mapcar #'second list)))
      (resolve-table 'igenylesek labels values))))


;;; ----------------------------------------------------------------------
;;; xarray -> temp


(defun collect-row-values (rows)
  "Collect values stored in ROWS into a list in row-major order."
  (let ((accum '())
        (width (xarray-width rows)))
    (do-xarows (row r rows)
      (push (loop for c from 0 below width collecting
;                  (xlval->sql (xcref row c)))
                  (transl (xcref row c) "xl>sql"))
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
                (pabort obj))))


;;; ----------------------------------------------------------------------
;;; temp -> fix (auto-resolve insertion)


;; Rewrite this using the new RESOLVE-... functions!
(defun temp->fix (temp obj step)
  "Move data from TEMP into fix tables."
  (let ((temp-header (table-columns temp))
        (temp-rows   (dump-table temp))
        (root-table  (root-table)))
    (dolist (row temp-rows)

      ;; RESOLVE-TABLE/VALUES don't exist anymore!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      (resolve-table
;       (resolve-values root-table temp-header row)
       temp-header root-table nil) ; fake arguments!

      (dump obj "~a~%~%" row)
      (pstep obj :step step)
      (pabort obj))))


;;; ----------------------------------------------------------------------
;;; Single row insert / update


#|  (let ((mapping (import-mapping 'tk)))
    (column-import 'anya_utonev_2 mapping)
    ...)

(defun insertdb (columns values)
  ...)

(defun updatedb (id columns values)
  ...)|#


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
