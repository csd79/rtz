;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; DB Schema


(defparameter *schema*
  
  '(:transl "sch>"


    :tables
    ;; Table names, column names & definitions
    ((:table igenylesek
      :columns ((:column igenyles_id
                 :desc (integer primary key))
                (:column szemely_id
                 :desc (integer not null))
                (:column igazolvanyszam
                 :desc (text not null))
                (:column szerv_egys_id
                 :desc (integer not null))
                (:column beosztas_id
                 :desc (integer not null))
                (:column telefon
                 :desc (text not null))
                (:column email
                 :desc (text not null))
                (:column t_sorozatszam
                 :desc (text unique))
                (:column t_ervenyesseg_kezdete
                 :desc (text)
                 :type :date)
                (:column t_ervenyesseg_vege
                 :desc (text)
                 :type :date)
                (:column t_tipus_id
                 :desc (integer))
                (:column t_kapcs_eszkoz_id
                 :desc (integer))
                (:column t_allapot_id
                 :desc (integer))
                (:column t_visszavonas_datuma
                 :desc (text)
                 :type :date
                 :impersonal t))
      :new-only nil)

     (:table t_tipusok
      :columns ((:column t_tipus_id
                 :desc (integer primary key))
                (:column t_tipus
                 :desc (text not null unique)
                 :impersonal t))
      :new-only t)

     (:table t_kapcs_eszkozok
      :columns ((:column t_kapcs_eszkoz_id
                 :desc (integer primary key))
                (:column t_kapcs_eszkoz
                 :desc (text not null unique)
                 :impersonal t))
      :new-only t)
     
     (:table t_allapotok
      :columns ((:column t_allapot_id
                 :desc (integer primary key))
                (:column t_allapot
                 :desc (text not null unique)
                 :impersonal t))
      :new-only t)
     
     (:table szerv_egysegek
      :columns ((:column szerv_egys_id
                 :desc (integer primary key))
                (:column tank_kozpont_id
;                 :desc (integer not null))
                 :desc (integer))
                (:column szerv_egys
                 :desc (text not null unique)
                 :impersonal t))
      :new-only t)

     (:table tank_kozpontok
;      :transl ">tkk"
      :columns ((:column tank_kozpont_id
                 :desc (integer primary key))
                (:column tank_kozpont
                 :desc (text not null unique)
                 :impersonal t
                 :transl "sch>tk"
                 ))
      :new-only t)
     
     (:table beosztasok
      :columns ((:column beosztas_id
                 :desc (integer primary key))
                (:column beosztas
                 :desc (text not null unique)))
      :new-only t)
     
     (:table szemelyek
      :columns ((:column szemely_id
                 :desc (integer primary key))
                (:column viselt_csaladnev
                 :desc (text not null))
                (:column viselt_utonev_1
                 :desc (text not null))
                (:column viselt_utonev_2
                 :desc (text not null))
                (:column szul_csaladnev
                 :desc (text not null))
                (:column szul_utonev_1
                 :desc (text not null))
                (:column szul_utonev_2
                 :desc (text not null))
                (:column anya_csaladnev
                 :desc (text not null))
                (:column anya_utonev_1
                 :desc (text not null))
                (:column anya_utonev_2
                 :desc (text not null))
                (:column varos_id
;                 :desc (integer not null))
                 :desc (integer))
                (:column szul_datuma
                 :desc (text not null)
                 :type :date
                 :transl "sch>date"))
      :new-only t)

     (:table varosok
      :columns ((:column varos_id
                 :desc (integer primary key))
                (:column orszag_id
;                 :desc (integer not null))
                 :desc (integer))
                (:column varos
                 :desc (text not null unique)
                 :impersonal t))
      :new-only t)

     (:table orszagok
      :columns ((:column orszag_id
                 :desc (integer primary key))
                (:column orszag
                 :desc (text not null unique)
                 :impersonal t))
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
      :columns ((igenyles_id           "ID"                              60)
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


    :imports
    ((:name      tk
      :default-p t
      :mapping   ((igazolvanyszam        "Igazolvány száma")
                  (telefon               "Telefon")
                  (email                 "E-mail")
                  (t_sorozatszam         "Tanúsítvány sorozatszáma")
                  (t_ervenyesseg_kezdete "Tanúsítvány érvényességének kezdete")
                  (t_ervenyesseg_vege    "Tanúsítvány érvényességének vége")
                  (t_visszavonas_datuma  "Visszavonás idõpontja")
                  (t_tipus               "Tanúsítvány típusa")
                  (t_kapcs_eszkoz        "Tanúsítványhoz kapcsolódó eszköz")
                  (t_allapot             "Tanúsítvány állapota")
                  (szerv_egys            "Szervezeti egység")
                  (tank_kozpont          "Tankerületi központ neve")
                  (beosztas              "Beosztás")
                  (viselt_csaladnev      "Viselt családnév")
                  (viselt_utonev_1       "Viselt utónév 1")
                  (viselt_utonev_2       "Viselt utónév 2")
                  (szul_csaladnev        "Születési családnév")
                  (szul_utonev_1         "Születési utónév 1")
                  (szul_utonev_2         "Születési utónév 2")
                  (anya_csaladnev        "Anyja születési családneve")
                  (anya_utonev_1         "Anyja születési utóneve 1")
                  (anya_utonev_2         "Anyja születési utóneve 2")
                  (szul_datuma           "Születési dátum")
                  (varos                 "Születési hely")
                  (orszag                "Születési ország")))

     (:name      nisz
      :default-p nil
      :mapping   ())
     )


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
