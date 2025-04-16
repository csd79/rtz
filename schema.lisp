;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; DB Schema


(defparameter *schema*
  
  '(:tables
    ;; Table names, column names & definitions
    ((:table igenylesek
      :columns ((:column igenyles_id           :desc (integer  primary key))
                (:column szemely_id            :desc (integer  not null))
                (:column igazolvanyszam        :desc (text     not null))
                (:column szerv_egys_id         :desc (integer  not null))
                (:column beosztas_id           :desc (integer  not null))
                (:column telefon               :desc (text     not null))
                (:column email                 :desc (text     not null))
                (:column t_sorozatszam         :desc (text     unique))
                (:column t_ervenyesseg_kezdete :desc (text))
                (:column t_ervenyesseg_vege    :desc (text))
                (:column t_tipus_id            :desc (integer))
                (:column t_kapcs_eszkoz_id     :desc (integer))
                (:column t_allapot_id          :desc (integer))
                (:column t_visszavonas_datuma  :desc (text))))

     (:table t_tipusok
      :columns ((:column t_tipus_id            :desc (integer  primary key))
                (:column t_tipus               :desc (text     not null      unique))))

     (:table t_kapcs_eszkozok
      :columns ((:column t_kapcs_eszkoz_id     :desc (integer  primary key))
                (:column t_kapcs_eszkoz        :desc (text     not null      unique))))

     (:table t_allapotok
      :columns ((:column t_allapot_id          :desc (integer  primary key))
                (:column t_allapot             :desc (text     not null      unique))))

     (:table szerv_egysegek
      :columns ((:column szerv_egys_id         :desc (integer  primary key))
                (:column tank_kozpont_id       :desc (integer  not null))
                (:column szerv_egys            :desc (text     not null      unique))))

     (:table tank_kozpontok
      :columns ((:column tank_kozpont_id       :desc (integer  primary key))
                (:column tank_kozpont          :desc (text     no null       unique))))

     (:table beosztasok
      :columns ((:column beosztas_id           :desc (integer  primary key))
                (:column beosztas              :desc (text     not null      unique))))

     (:table szemelyek
      :columns ((:column szemely_id            :desc (integer  primary key))
                (:column viselt_csaladnev      :desc (text     not null))
                (:column viselt_utonev_1       :desc (text     not null))
                (:column viselt_utonev_2       :desc (text     not null))
                (:column szul_csaladnev        :desc (text     not null))
                (:column szul_utonev_1         :desc (text     not null))
                (:column szul_utonev_2         :desc (text     not null))
                (:column anya_csaladnev        :desc (text     not null))
                (:column anya_utonev_1         :desc (text     not null))
                (:column anya_utonev_2         :desc (text     not null))
                (:column varos_id              :desc (integer  not null))
                (:column szul_datuma           :desc (text     not null))))

     (:table varosok
      :columns ((:column varos_id              :desc (integer  primary key))
                (:column orszag_id             :desc (integer  not null))
                (:column varos                 :desc (text     not null      unique))))

     (:table orszagok
      :columns ((:column orszag_id             :desc (integer  primary key))
                (:column orszag                :desc (text     not null      unique)))))
    

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


    :views
    ;; :MAIN is for browsing & exporting to Excel
    (:main (tank_kozpont
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
            t_sorozatszam
            t_ervenyesseg_kezdete
            t_ervenyesseg_vege
            t_tipus
            t_kapcs_eszkoz
            t_allapot
            t_visszavonas_datuma))))
