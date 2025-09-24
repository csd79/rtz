;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; DB Schema


(defparameter *schema*
  
  '(:tables
    ;; Table names, column names & definitions
    ((:table igenylesek
      :columns ((:column igenyles_id
                 :desc (integer primary key))
                (:column szemely_id
                 :desc (integer not null))
                (:column igazolvanyszam
                 :desc (text not null)
                 :import "Igazolvány száma")
                (:column szerv_egys_id
                 :desc (integer not null))
                (:column beosztas_id
                 :desc (integer not null))
                (:column telefon
                 :desc (text not null)
                 :import "Telefon")
                (:column email
                 :desc (text not null)
                 :import "E-mail")
                (:column t_sorozatszam
                 :desc (text unique)
                 :import "Tanúsítvány sorozatszáma")
                (:column t_ervenyesseg_kezdete
                 :desc (text)
                 :type :date
                 :import "Tanúsítvány érvényességének kezdete")
                (:column t_ervenyesseg_vege
                 :desc (text)
                 :type :date
                 :import "Tanúsítvány érvényességének vége")
                (:column t_tipus_id
                 :desc (integer))
                (:column t_kapcs_eszkoz_id
                 :desc (integer))
                (:column t_allapot_id
                 :desc (integer))
                (:column t_visszavonas_datuma
                 :desc (text)
                 :type :date
                 :import "Visszavonás idõpontja"
                 :impersonal t
                 ))
      :new-only nil)

     (:table t_tipusok
      :columns ((:column t_tipus_id
                 :desc (integer primary key))
                (:column t_tipus
                 :desc (text not null unique)
                 :import "Tanúsítvány típusa"
                 :impersonal t
                 ))
      :new-only t)

     (:table t_kapcs_eszkozok
      :columns ((:column t_kapcs_eszkoz_id
                 :desc (integer primary key))
                (:column t_kapcs_eszkoz
                 :desc (text not null unique)
                 :import "Tanúsítványhoz kapcsolódó eszköz"
                 :impersonal t
                 ))
      :new-only t)
     
     (:table t_allapotok
      :columns ((:column t_allapot_id
                 :desc (integer primary key))
                (:column t_allapot
                 :desc (text not null unique)
                 :import "Tanúsítvány állapota"
                 :impersonal t
                 ))
      :new-only t)
     
     (:table szerv_egysegek
      :columns ((:column szerv_egys_id
                 :desc (integer primary key))
                (:column tank_kozpont_id
;                     :desc (integer not null))
                 :desc (integer))
                (:column szerv_egys
                 :desc (text not null unique)
                 :import "Szervezeti egység"
                 :impersonal t
                 ))
      :new-only t)

     (:table tank_kozpontok
      :columns ((:column tank_kozpont_id
                 :desc (integer primary key))
                (:column tank_kozpont
                 :desc (text not null unique)
                 :import "Tankerületi központ neve"
                 :impersonal t
                 ))
      :new-only t)
     
     (:table beosztasok
      :columns ((:column beosztas_id
                 :desc (integer primary key))
                (:column beosztas
                 :desc (text not null unique)
                 :import "Beosztás"))
      :new-only t)
     
     (:table szemelyek
      :columns ((:column szemely_id
                 :desc (integer primary key))
                (:column viselt_csaladnev
                 :desc (text not null)
                 :import "Viselt családnév")
                (:column viselt_utonev_1
                 :desc (text not null)
                 :import "Viselt utónév 1")
                (:column viselt_utonev_2
                 :desc (text not null)
                 :import "Viselt utónév 2")
                (:column szul_csaladnev
                 :desc (text not null)
                 :import "Születési családnév")
                (:column szul_utonev_1
                 :desc (text not null)
                 :import "Születési utónév 1")
                (:column szul_utonev_2
                 :desc (text not null)
                 :import "Születési utónév 2")
                (:column anya_csaladnev
                 :desc (text not null)
                 :import "Anyja születési családneve")
                (:column anya_utonev_1
                 :desc (text not null)
                 :import "Anyja születési utóneve 1")
                (:column anya_utonev_2
                 :desc (text not null)
                 :import "Anyja születési utóneve 2")
                (:column varos_id
;                     :desc (integer not null))
                 :desc (integer))
                (:column szul_datuma
                 :desc (text not null)
                 :type :date
                 :import "Születési dátum"))
      :new-only t)

     (:table varosok
      :columns ((:column varos_id
                 :desc (integer primary key))
                (:column orszag_id
;                     :desc (integer not null))
                 :desc (integer))
                (:column varos
                 :desc (text not null unique)
                 :import "Születési hely"
                 :impersonal t
                 ))
      :new-only t)

     (:table orszagok
      :columns ((:column orszag_id
                 :desc (integer primary key))
                (:column orszag
                 :desc (text not null unique)
                 :import "Születési ország"
                 :impersonal t
                 ))
      :new-only t)

     (:table users
      :columns ((:column user_id
                 :desc (integer primary key))
                (:column username
                 :desc (text not null))
                (:column full_name
                 :desc (text not null))
                (:column password_mandatory_p
                 :desc (integer))
                (:column password
                 :desc (text))
                (:column active_p
                 :desc (integer))
                (:column admin_p
                 :desc (integer))
                (:column created_on
                 :desc (text not null)))
      :new-only t)

     (:table user_filter
      :columns ((:column user_id
                 :desc (integer))
                (:column tank_kozpont_id
                 :desc (integer primary key)))
      :new-only t)
     )


    :connections
    ;; 'Many' table, 'one' table, connecting column
    ((igenylesek      szemelyek         szemely_id)
     (igenylesek      szerv_egysegek    szerv_egys_id)
     (igenylesek      beosztasok        beosztas_id)
     (igenylesek      t_tipusok         t_tipus_id)
     (igenylesek      t_kapcs_eszkozok  t_kapcs_eszkoz_id)
     (igenylesek      t_allapotok       t_allapot_id)
     (szerv_egysegek  tank_kozpontok    tank_kozpont_id)
     (szemelyek       varosok           varos_id)
     (varosok         orszagok          orszag_id))


    :views
    ;; :MAIN is for browsing & exporting to Excel
    (:main
     (:id      igenyles_id
      :order   (igenyles_id asc)
      :columns ((igenyles_id           "ID"                              60);;;;;;;;;;;;;;;;
                (tank_kozpont          "Tankerületi központ"             140)
                (szerv_egys            "Intézmény"                       200)
                (beosztas              "Beosztás"                        140)
                (viselt_csaladnev      "Családnév"                       90)
                (viselt_utonev_1       "1. utónév"                       90)
                (viselt_utonev_2       "2. utónév"                       90)
                (szul_csaladnev        "Szül. családnév"                 90)
                (szul_utonev_1         "Szül. 1. utónév"                 90)
                (szul_utonev_2         "Szül. 2. utónév"                 90)
                (anya_csaladnev        "Anya leánykori családnév"        90)
                (anya_utonev_1         "Anya leánykori 1. utónév"        90)
                (anya_utonev_2         "Anya leánykori 2. utónév"        90)
                (orszag                "Születési ország"                90)
                (varos                 "Születési város"                 90)
                (szul_datuma           "Születési dátum"                 80)
                (igazolvanyszam        "Igazolványszám"                  80)
                (telefon               "Telefonszám"                     90)
                (email                 "E-mail cím"                      140)
                (t_sorozatszam         "Tanúsítvány sorozatszám"         160)
                (t_ervenyesseg_kezdete "Tanúsítvány érvényesség kedzete" 80)
                (t_ervenyesseg_vege    "Tanúsítvány érvényesség vége"    80)
                (t_tipus               "Tanúsítvány típusa"              90)
                (t_kapcs_eszkoz        "Kapcsolódó eszköz"               90)
                (t_allapot             "Tanúsítvány státusza"            90)
                (t_visszavonas_datuma  "Visszavonás dátuma"              80))))


    :filters
    (:main (tank_kozpont
            szerv_egys
            beosztas
            ("Viselt név" viselt_csaladnev viselt_utonev_1 viselt_utonev_2)
            ("Születési név" szul_csaladnev szul_utonev_1 szul_utonev_2)
            ("Anya leánykori neve" anya_csaladnev anya_utonev_1 anya_utonev_2)
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
            t_visszavonas_datuma))

    
    :root igenylesek
    ))
