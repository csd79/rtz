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
  (let* ((end     (min height (+ start *rows-per-statement*)))
;  (let* ((end     (min (1- height) (+ start *rows-per-statement*)))
;         (indices (loop for i from start upto end collecting i)))
         (indices (loop for i from start below end collecting i)))
    (xarows xarray (coerce indices 'vector))))


#|(defun import-xarray (table xarray)
  "Go over rows of XARRAY by groups, import them into TABLE."
  (let ((height (xarray-indexed-height xarray)))
    (wax::with-progress ("Excel importálás" abort dump move height)
      (loop for start from 0 below height by *rows-per-statement*
            for rows  = (group-rows xarray start height)
            for step  = (xarray-indexed-height rows)
            for vals  = (collect-row-values rows)
            doing (apply #'insert-into table (column-names xarray) nil vals)
                  (dump "Sorok: ~a - ~a~%" start (+ start step -1))
                  (move :step step)
                  (abort)))))|#
(defun import-xarray (table obj)
  "Go over rows of the source in OBJ by groups, import them into TABLE."
  (let* ((xarray (source-data obj :import))
         (height (xarray-indexed-height xarray)))
    (loop for start from 0 below height by *rows-per-statement*
          for rows  = (group-rows xarray start height)
          for step  = (xarray-indexed-height rows)
          for vals  = (collect-row-values rows)
          doing (apply #'insert-into table (column-names xarray) nil vals)
                (dump obj "Sorok: ~a - ~a~%" start (+ start step -1))
                (pstep obj :step step)
                (pabort obj))))


;;; ----------------------------------------------------------------------
;;; temp -> fix (auto-resolve insertion)


#|(defun resolve-immediate (t-column table v-columns values)
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
;  (let* ((many         (many-joins table))
  (let ((foreign-desc (find-if #'(lambda (element)
                                   (and (eq (first element) table)
                                        (eq (third element) t-column)))
;                               many)))
                               (many-joins table))))
    (if foreign-desc
      (resolve-insert (second foreign-desc) values v-columns)
      'foreign-not-found)))


(defun insert-values-into (table values)
  "Insert VALUES into a new row in TABLE's columns (except primary key)."
  (let ((fix-columns (remove-if #'(lambda (column)
                                    (primary-key-p column table))
                                (schema-columns table)))
        (new-only    (new-only-p table))
        (fix-values  (remove 'possible-primary-key values)))
    (apply #'insert-into table fix-columns new-only fix-values)))


(defun resolve-insert (fix-table temp-vals temp-heads)
  "Insert TEMP-VALS into FIX-TABLE; trickle foreign values down into their respective tables; should be called with root table."
  (let ((fix-heads (schema-columns fix-table)))
    (insert-values-into fix-table
     (mapcar #'(lambda (t-header)
                 (cond ((immediate-p t-header fix-table)
                        (resolve-immediate t-header fix-table temp-heads temp-vals))
                       ((foreign-p t-header fix-table)
                        (resolve-foreign fix-table t-header temp-heads temp-vals))
                       (t 'possible-primary-key)))
             fix-heads))))|#

#|(defparameter h '("szervezeti_egyseg" "beosztas" "viselt_csaladnev" "viselt_utonev_1" "viselt_utonev_2" "szuletesi_csaladnev" "szuletesi_utonev_1" "szuletesi_utonev_2" "anyja_szuletesi_csaladneve" "anyja_szuletesi_utoneve_1" "anyja_szuletesi_utoneve_2" "szuletesi_orszag" "szuletesi_hely" "szuletesi_datum" "igazolvany_szama" "telefon" "e_mail" "tankeruleti_kozpont_neve" "tanusitvany_sorozatszama" "tanusitvany_ervenyessegenek_kezdete" "tanusitvany_ervenyessegenek_vege" "tanusitvany_tipusa" "tanusitvanyhoz_kapcsolodo_eszkoz" "tanusitvany_allapota" "visszavonva" "visszavonas_idopontja"))

(defparameter v '("Békéscsabai Petõfi Utcai Általános Iskola" "Igazgatóhelyettes" "Tóth" "Lászlóné" "NULL" "Hegedûs" "Kitti" "NULL" "Illés" "Tünde" "Ágnes" "Magyarország" "Budapest III" "1959-05-23" "131461SR" "+36 30 987 6543" "laszlone.toth@isi55.hu" "Békéscsabai Tankerületi Központ" "C1CQ6R6ERB2413F9" "2024-02-13" "2027-02-13" "alibi" "Szoftveres (kazetta)" "Érvényes" "NULL" "NULL"))|#


(defun resolve-values (table temp-columns temp-values)
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
                            (list :column column (resolve-values foreign-table temp-columns temp-values)))))
                    columns))))


#|(defun resolve-table (list)
  (destructuring-bind (flag name &rest subs)
      list
    (let ((columns '())
          (values  '()))
      (dolist (row subs)
        (destructuring-bind (flag name &rest rest)
            row
          (if (eq flag :column)
            (progn
              (push name columns)
              (push (first rest) values))
            (resolve-table row))))
      (values columns values))))|#


(defun primary-key (table)
  "What column is the primary key of TABLE?"
  (find-if #'(lambda (column)
               (primary-key-p column table))
           (schema-columns table)))


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
#|      (let ((col (second list))
            (val (third list)))|#
      (let ((col (second row))
            (val (third row)))
        (push col columns)
        ;; If value is a sublist, resolve that first
        (push (if (consp val) (resolve-table val) val)
              values)))
    ;; Making a statement
    (apply #'insert-into name columns t values)
    (first (first (select (list (primary-key name)) :from name :where (andeq columns values))))))


(defun temp->fix (temp obj)
  (let ((temp-header (table-columns temp))
        (temp-rows   (dump-table temp))
        (root-table  (root-table)))
    (dolist (row temp-rows)
      (resolve-table
       (resolve-values root-table temp-header row))
      (dump obj "~a~%" row)
      (pstep obj)
      (pabort obj))))


;;; ----------------------------------------------------------------------
;;; Operations


(defun import-xlsx (obj)
  "Import XLSX into a new temp table in DB."
  (load-data-source obj :import)
  (let ((xarray (source-data obj :import)))
    (wax::with-progress-new ("Excel importálás" obj (* (xarray-indexed-height xarray) 2))
      (dump obj "Táblázat megnyitása.~%")
      (let ((temp (unique-table-name "user")))
        (create-table temp (column-names xarray))


      #|  (let ((xarray (get-xarray xlsx))
                (temp   (unique-table-name infix))
                (obj    (make-instance 
                         (create-table temp (column-names xarray))
                         (import-xarray temp xarray)|#


        (import-xarray temp obj)
;        (pstep obj :abs 0.01)
        (temp->fix temp obj)
        )))
  
#|      (let ((temp-header (table-columns temp))
            (temp-rows   (dump-table temp))
            (root-table  (root-table)))
        (dolist (row temp-rows)
          (resolve-table
           (resolve-values root-table temp-header row))
          (print row)
          ))|#


#|      (select `(,(col 'igenyles_id 'igenylesek))
            :from (root-table)
            :left-join '(igenylesek szerv_egysegek szerv_egys_id)
            :left-join '(szerv_egysegek tank_kozpontok tank_kozpont_id)
            :where `(,(col 'tank_kozpont 'tank_kozpontok) = "Egri Tankerületi Központ"))|#

;      (sql->list "select IGENYLESEK.IGENYLES_ID FROM IGENYLESEK LEFT JOIN IGENYLESEK ON SZERV_EGYSEGEK.IGENYLESEK = SZERV_EGYS_ID.IGENYLESEK WHERE TANK_KOZPONTOK.TANK_KOZPONT = 'Egri Tankerületi Központ'")
;      (sql->list "select igenylesek.igenyles_id FROM IGENYLESEK LEFT JOIN IGENYLESEK ON SZERV_EGYSEGEK.IGENYLESEK = SZERV_EGYS_ID.IGENYLESEK WHERE TANK_KOZPONTOK.TANK_KOZPONT = 'Egri Tankerületi Központ';")
;      (sql->list "select IGENYLES_ID FROM IGENYLESEK LEFT JOIN SZERV_EGYSEGEK ON IGENYLESEK.SZERV_EGYS_ID = SZERV_EGYSEGEK.SZERV_EGYS_ID LEFT JOIN TANK_KOZPONTOK ON SZERV_EGYSEGEK.TANK_KOZPONT_ID = TANK_KOZPONTOK.TANK_KOZPONT_ID WHERE TANK_KOZPONTOK.TANK_KOZPONT = 'Egri Tankerületi Központ'")
    (select '(igenyles_id)
            :from 'igenylesek
            :left-join '((igenylesek szerv_egysegek szerv_egys_id)
                         (szerv_egysegek tank_kozpontok tank_kozpont_id))
            :where `(,(col 'tank_kozpont 'tank_kozpontok) = "Egri Tankerületi Központ"))

            ;;;;;; olyan kéne ahol nem kell explicit left join és where láncolat, csak
            ;;;;;; tank-kozp = Eger
            ;;;;;; Feltételezzük h az összes tábla- ás oszlopnév egyedi, kivéve azok amelyek
            ;;;;;; a kapcsolatokat biztosítják!
    )
