;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; Basics


(defun resolve-column (column columns values)
  "Helper for RESOLVE-TABLE, constructing subtree for COLUMN."
  (let ((pos   (position column columns))                       ;   Did we provide a value for COLUMN?
        (table (first (table column :foreign-allowed t))))      ;   The table that contains COLUMN as a foreign key.
    (if (immediate-p column table)                              ; If COLUMN is an immediate value & not a key:
      (when pos `(:column ,column ,(nth pos values)))           ;   => (:COLUMN <column> <val>) or NIL if value isn't provided
      (let ((result (resolve-table (foreign-table table column) ; If COLUMN is not immediate:
                                   columns values)))            ;   Subexpression for foreign table
        (when result `(:column ,column ,result))))))            ; => (:COLUMN <column> (:TABLE ...)) or NIL if result is NIL


(defun resolve-table (table columns values)
  "Construct a tree that describes columns and their values, plus their links across tables.
   RESOLVE-STATEMENT will perform insert-calls guided by this tree. Example:
     (:TABLE IGENYLESEK
       (:COLUMN SZEMELY_ID     ; foreign key linking tables IGENYLESEK & SZEMELYEK
         (:TABLE SZEMELYEK     ; inside SZEMELYEK, some immediate values:
           (:COLUMN VISELT_CSALADNEV 'Wayne') (:COLUMN VISELT_UTONEV_1 'Bruce') ...)) ...)"
  (let ((subexps
    (loop for current in (schema-columns table)               ; Every column but the primary key in TABLE
          unless (primary-key-p current table)
          collect (resolve-column current columns values))))  ; List of column subexpressions
    (when subexps `(:table ,table ,@subexps))))               ; If there were any, list them


(defun where= (columns values)
  "WHERE clause where every COLUMNS equal VALUES one by one."
  (let ((mains (mapcar #'(lambda (col val) (list col '= val 'and)) columns values)))
    (butlast (apply #'nconc mains))))


(defun resolve-statement (tree)
  "Insert values into tables. The guiding TREE must be generated using RESOLVE-TABLE."
  (let ((table (second tree)))
    (loop for row in (cddr tree)                                      ; For each column:
          for exp = (third row)
          for val = (if (consp exp) (resolve-statement exp) exp)      ; If value is a subtree, resolve it first
          collecting (second row) into columns                        ; Collect column names and values
          collecting val into values
          finally (progn (apply #'insert-into table columns t values) ; Insert row into TABLE
                    (return (caar (select (list (primary-key table))  ; Return new row ID
                                          :from table :where
                                          (where= columns values))))))))


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
                     (TANK_KOZPONT "Kansas Southern Dustbowl")
                     (SZERV_EGYS "Smallville High")
                     (BEOSZTAS "Iskolaújság szerkesztõ")
                     (TELEFON "888-naci")
                     (EMAIL "sup@fort.soli")
                     (T_SOROZATSZAM "9876543210")
                     (T_ERVENYESSEG_KEZDETE "2025-07-29")
                     (T_ERVENYESSEG_VEGE "2025-12-31")
                     (T_TIPUS "GHVC")
                     (T_KAPCS_ESZKOZ "Kristály")
                     (T_ALLAPOT "Megújuló")
                     (T_VISSZAVONAS_DATUMA "9999-12-31")))


(defun insert-new-test (list)
  (with-db-context
    (verify-statements (:execute t)
      (let ((*sqlfn* #'sql->list)
            (labels  (mapcar #'first list))
            (values  (mapcar #'second list)))
        (resolve-statement
         (resolve-table 'igenylesek labels values))))))

(defun resolve-table-test (list)
  (with-db-context
    (let ((*sqlfn* #'sql->list)
          (labels  (mapcar #'first list))
          (values  (mapcar #'second list)))
      (resolve-table 'igenylesek labels values))))


#|
 A legtöbb mezõt kötelezõ megadni, ezért pár mezõs hívásokkal esélytelen ezt tesztelni.


 Az a sok izé amit az INSERT-NEW-TEST kiír, a verify-statements eredménye. Minden táblába való beszúrás után lekérdez hogy megkapja a háttértábla id-jét, ami megy a fõtáblába.
 
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




;; Rewrite this using the new RESOLVE-... functions!
(defun temp->fix (temp obj step)
  "Move data from TEMP into fix tables."
  (let ((temp-header (table-columns temp))
        (temp-rows   (dump-table temp))
        (root-table  (root-table)))
    (dolist (row temp-rows)
      (resolve-table                 ; WRONG NUMBER OF ARGUMENTS!
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
