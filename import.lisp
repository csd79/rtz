;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; xarray -> temp


(defun collect-row-values (rows)
  "Collect values stored in ROWS into a list in row-major order."
  (with-transl (*rtz-translators* :verify nil)
    (let ((accum '())
          (width (xarray-width rows)))
      (do-xarows (row r rows)
        (push (loop for c from 0 below width collecting
;                  (xlval->sql (xcref row c)))
                    (transl (xcref row c) "xl>prg"))
              accum))
      (apply #'nconc (nreverse accum)))))


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
          doing (apply #'insert table (column-names xarray t) nil vals)
                (dump obj "Sorok: ~a - ~a~%" start (+ start height2 -1))
                (pstep obj :step (* step *rows-per-statement*))
                (pabort obj))))


;;; ----------------------------------------------------------------------
;;; temp -> fix (auto-resolve insertion)


;; Rewrite this using the new RESOLVE-... functions!
(defun temp->fix (temp obj step key)
  "Move data from TEMP into fix tables."
  (verify-statements (:execute t)
  (let* ((column-names (column-names (source-data obj key) nil))
;        (temp-header  (table-columns temp))
         (temp-header  (map-import column-names))
         (temp-rows    (dump-table temp))
;        (root-table   (root-table))
         )
#|    (multiple-value-bind (header fails)
        (map-import temp-header)
      (declare (ignore fails))|#
    (dump obj "~a~%~a~5%" temp-header (length temp-header))
    (dolist (row temp-rows)
;      (dump obj "~a~5%" (length row))

      (smart-insert (mapcar #'list temp-header row) "")
;      (dump obj "~{~a~%~}~%" (mapcar #'list temp-header row))

      (dump obj "~a~%~%" row)
      (pstep obj :step step)
      (pabort obj)
      )))
  )
;)

;(column-names (source-data obj key) t)



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
;           (*sqlfn* #'sql->list)
           )
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
                  (create-table temp (column-names (source-data obj key) t))
                  (import-xarray temp obj key step-import)
                  (dump obj "~%Adatok véglegesítése...~%~%")
                  (temp->fix temp obj step-fix key)
                  (drop-table temp)
                  (wax::purge-data-source obj key)))))


;;; ----------------------------------------------------------------------
;;; Sandbox


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
;                     (TANK_KOZPONT "Szigetszentmiklósi Tankerületi Központ")
                     (TANK_KOZPONT "Szigetszentmiklósi TK")
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


(defparameter *b4* '((SZERVEZETI_EGYSEG "Egri Pásztorvölgyi Általános Iskola és Gimnázium")
                     (BEOSZTAS "Igazgató")
                     (VISELT_CSALADNEV "Nagy")
                     (VISELT_UTONEV_1 "Jánosnécske")
                     (SZULETESI_CSALADNEV "Szilágyicska")
                     (SZULETESI_UTONEV_1 "Ágnesecske")
                     (ANYJA_SZULETESI_CSALADNEVE "Illésecske")
                     (ANYJA_SZULETESI_UTONEVE_1 "Rozáliácska")
                     (SZULETESI_ORSZAG "Magyarország")
                     (SZULETESI_HELY "Veszprém")
                     (SZULETESI_DATUM "20916.0D0")
                     (IGAZOLVANY_SZAMA "151538SM")
                     (TELEFON "2036-01-23")
                     (E_MAIL "agnes.szilagyix@suli13.hu")
                     (TANKERULETI_KOZPONT_NEVE "Egri Tankerületi Központ")
                     (TANUSITVANY_SOROZATSZAMA "JI6N3EBI2D9PLIU9")
                     (TANUSITVANY_ERVENYESSEGENEK_KEZDETE "2022-08-21")
                     (TANUSITVANY_ERVENYESSEGENEK_VEGE "2025-08-21")
                     (TANUSITVANY_TIPUSA "alibi")
                     (TANUSITVANYHOZ_KAPCSOLODO_ESZKOZ "Hardveres (CD)")
                     (TANUSITVANY_ALLAPOTA "Érvényes")))


(defun insert-update-test ()
  (verify-statements (:execute t)
    (let ((ids (mapcar #'(lambda (row)
                           (smart-insert row ""))
                       (list *b1* *b2*))))
      (smart-update ids *b3* ""))))


(defun resolve-table-test (list)
  (with-db-context
    (let (
;(*sqlfn* #'sql->list)
          (labels  (mapcar #'first list))
          (values  (mapcar #'second list)))
      (resolve-table 'igenylesek labels values))))
