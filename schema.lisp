;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; DB Schema


(defparameter *schema*
  
  '(:tables
    ;; Table names, column names & definitions
    ((:table igenylesek
      :columns ((igenyles_id           integer  primary key)
                (szemely_id            integer  not null)
                (igazolva nyszam        text     not null)
                (szerv_egys_id         integer  not null)
                (beosztas_id           integer  not null)
                (telefon               text     not null)
                (email                 text     not null)
                (kinevezes_kezdete     text     not null) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                (kinevezes_vege        text     not null) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                (t_sorozatszam         text)
                (t_ervenyesseg_kezdete text)
                (t_ervenyesseg_vege    text)
                (t_tipus_id            integer)
                (t_kapcs_eszkoz_id     integer)
                (t_allapot_id          integer)
                (t_visszavonas_datuma  text)))

     (:table t_tipusok
      :columns ((t_tipus_id            integer  primary key)
                (t_tipus               text     not null)))

     (:table t_kapcs_eszkozok
      :columns ((t_kapcs_eszkoz_id     integer  primary key)
                (t_kapcs_eszkoz        text     not null)))

     (:table t_allapotok
      :columns ((t_allapot_id          integer  primary key)
                (t_allapot             text     not null)))

     (:table szerv_egysegek
      :columns ((szerv_egys_id         integer  primary key)
                (tank_kozpont_id       integer  not null)
                (szerv_egys            text     not null)))

     (:table tank_kozpontok
      :columns ((tank_kozpont_id       integer  primary key)
                (tank_kozpont          text     no null)))

     (:table beosztasok
      :columns ((beosztas_id           integer  primary key)
                (beosztas              text     not null)))

     (:table szemelyek
      :columns ((szemely_id            integer  primary key)
                (viselt_csaladnev      text     not null)
                (viselt_utonev_1       text     not null)
                (viselt_utonev_2       text     not null)
                (szul_csaladnev        text     not null)
                (szul_utonev_1         text     not null)
                (szul_utonev_2         text     not null)
                (anya_csaladnev        text     not null)
                (anya_utonev_1         text     not null)
                (anya_utonev_2         text     not null)
                (varos_id              integer  not null)
                (szul_datuma           text     not null)))

     (:table varosok
      :columns ((varos_id              integer  primary key)
                (orszag_id             integer  not null)
                (varos                 text     not null)))

     (:table orszagok
      :columns ((orszag_id             integer  primary key)
                (orszag                text     not null))))

    
    :connections
    ;; 'Many' table, 'one' table, connecting column
    ((igenylesek      szemelyek         szemely_id)
     (igenylesek      szerv_egysegek    szerv_egys_id)
     (igenylesek      beosztasok        beosztas_id)
     (igenylesek      t_tipusok         t_tipus_id)
     (igenylesek      t_kapcs_eszkozok  t_kapcs_eszkoz_id)
     (igenylesek      t_allapotok       t_allapot_id)
     (szerv_egysegek  rank_kozpontok    tank-kozpont_id)
     (szemelyek       varosok           varos_id)
     (varosok         orszagok          orszag_id))


    :view
    (tank_kozpont
     szerv_egys
     beosztas
     viselt_csaladnev
     viselt_utonev_1
     viselt_utonev_2
     szul_csaladnev
     szul_utonev_1
     szul_utonev_2
     anya_csaladnev
     anya_utonev_1
     anya_utonev_2
     orszag
     varos
     szul_datuma
     igazolvanyszam
     telefon
     email
     kinevezes_kezdete ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     kinevezes_vege    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     t_sorozatszam
     t_ervenyesseg_kezdete
     t_ervenyesseg_vege
     t_tipus
     t_kapcs_eszkoz
     t_allapot
     t_visszavonas_datuma)))


;;; ----------------------------------------------------------------------
;;; Utilities


(defun find-schema-table (table &optional (schema *schema*))
  (find-if #'(lambda (record) (eq (getf record :table) table))
           (getf schema :tables)))


(defun find-column (column table-desc)
  (find-if #'(lambda (record) (eq (first record) column))
           (getf table-desc :columns)))


(defun list-schema-table-names (&optional (schema *schema*))
  (mapcar #'(lambda (table) (getf table :table)) (getf schema :tables)))


(defun list-schema-table-columns(table &optional (schema *schema*))
    (mapcar #'first (getf (find-schema-table table schema) :columns)))


(defun column-description (table column &optional (schema *schema*))
  (rest (find-column column (find-schema-table table schema))))
