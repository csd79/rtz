;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Initialize database


(defparameter *tk-synonyms*
  '(("Bajai Tankerületi Központ" "Bajai TK" "Bajai" "Baja")
    ("Balassagyarmati Tankerületi Központ" "Balassagyarmati TK" "Balassagyarmati" "Balassagyarmat")
    ("Balatonfüredi Tankerületi Központ" "Balatonfüredi TK" "Balatonfüredi" "Balatonfüred")
    ("Békéscsabai Tankerületi Központ" "Békéscsabai TK" "Békéscsabai" "Békéscsaba")
    ("Belsõ-Pesti Tankerületi Központ" "Belsõ-Pesti TK" "Belsõ-Pesti" "Belsõ-Pest")
    ("Berettyóújfalui Tankerületi Központ" "Berettyóújfalui TK" "Berettyóújfalui" "Berettyóújfalu")
    ("Ceglédi Tankerületi Központ" "Ceglédi TK" "Ceglédi" "Cegléd")
    ("Debreceni Tankerületi Központ" "Debreceni TK" "Debreceni" "Debrecen")
    ("Dél-Budai Tankerületi Központ" "Dél-Budai TK" "Dél-Budai" "Dél-Buda")
    ("Dél-Pesti Tankerületi Központ" "Dél-Pesti TK" "Dél-Pesti" "Dél-Pest")
    ("Dunakeszi Tankerületi Központ" "Dunakeszi TK" "Dunakeszi" "Dunakesz")
    ("Dunaújvárosi Tankerületi Központ" "Dunaújvárosi TK" "Dunaújvárosi" "Dunaújváros")
    ("Egri Tankerületi Központ" "Egri TK" "Egri" "Eger")
    ("Érdi Tankerületi Központ" "Érdi TK" "Érdi" "Érd")
    ("Észak-Budapesti Tankerületi Központ" "Észak-Budapesti TK" "Észak-Budapesti" "Észak-Budapest")
    ("Észak-Pesti Tankerületi Központ" "Észak-Pesti TK" "Észak-Pesti" "Észak-Pest")
    ("Esztergomi Tankerületi Központ" "Esztergomi TK" "Esztergomi" "Esztergom")
    ("Gyõri Tankerületi Központ" "Gyõri TK" "Gyõri" "Gyõr")
    ("Gyulai Tankerületi Központ" "Gyulai TK" "Gyulai" "Gyula")
    ("Hajdúböszörményi Tankerületi Központ" "Hajdúböszörményi TK" "Hajdúböszörményi" "Hajdúböszörmény")
    ("Hatvani Tankerületi Központ" "Hatvani TK" "Hatvani" "Hatvan")
    ("Hódmezõvásárhelyi Tankerületi Központ" "Hódmezõvásárhelyi TK" "Hódmezõvásárhelyi" "Hódmezõvásárhely")
    ("Jászberényi Tankerületi Központ" "Jászberényi TK" "Jászberényi" "Jászberény")
    ("Kaposvári Tankerületi Központ" "Kaposvári TK" "Kaposvári" "Kaposvár")
    ("Karcagi Tankerületi Központ" "Karcagi TK" "Karcagi" "Karcag")
    ("Kazincbarcikai Tankerületi Központ" "Kazincbarcikai TK" "Kazincbarcikai" "Kazincbarcika")
    ("Kecskeméti Tankerületi Központ" "Kecskeméti TK" "Kecskeméti" "Kecskemét")
    ("Kelet-Pesti Tankerületi Központ" "Kelet-Pesti TK" "Kelet-Pesti" "Kelet-Pest")
    ("Kiskõrösi Tankerületi Központ" "Kiskõrösi TK" "Kiskõrösi" "Kiskõrös")
    ("Kisvárdai Tankerületi Központ" "Kisvárdai TK" "Kisvárdai" "Kisvárda")
    ("Közép-Budai Tankerületi Központ" "Közép-Budai TK" "Közép-Budai" "Közép-Buda")
    ("Közép-Pesti Tankerületi Központ" "Közép-Pesti TK" "Közép-Pesti" "Közép-Pest")
    ("Külsõ-Pesti Tankerületi Központ" "Külsõ-Pesti TK" "Külsõ-Pesti" "Külsõ-Pest")
    ("Mátészalkai Tankerületi Központ" "Mátészalkai TK" "Mátészalkai" "Mátészalka")
    ("Mezõkövesdi Tankerületi Központ" "Mezõkövesdi TK" "Mezõkövesdi" "Mezõkövesd")
    ("Miskolci Tankerületi Központ" "Miskolci TK" "Miskolci" "Miskolc")
    ("Mohácsi Tankerületi Központ" "Mohácsi TK" "Mohácsi" "Mohács")
    ("Monori Tankerületi Központ" "Monori TK" "Monori"  "Monor")
    ("Nagykanizsai Tankerületi Központ" "Nagykanizsai TK" "Nagykanizsai" "Nagykanizsa")
    ("Nyíregyházi Tankerületi Központ" "Nyíregyházi TK" "Nyíregyházi" "Nyíregyháza")
    ("Pápai Tankerületi Központ" "Pápai TK" "Pápai" "Pápa")
    ("Pécsi Tankerületi Központ" "Pécsi TK" "Pécsi" "Pécs")
    ("Salgótarjáni Tankerületi Központ" "Salgótarjáni TK" "Salgótarjáni" "Salgótarján")
    ("Sárospataki Tankerületi Központ" "Sárospataki TK" "Sárospataki" "Sárospatak")
    ("Sárvári Tankerületi Központ" "Sárvári TK" "Sárvári" "Sárvár")
    ("Siófoki Tankerületi Központ" "Siófoki TK" "Siófoki" "Siófok")
    ("Soproni Tankerületi Központ" "Soproni TK" "Soproni" "Sopron")
    ("Szegedi Tankerületi Központ" "Szegedi TK" "Szegedi" "Szeged")
    ("Székesfehérvári Tankerületi Központ" "Székesfehérvári TK" "Székesfehérvári" "Székesfehérvár")
    ("Szekszárdi Tankerületi Központ" "Szekszárdi TK" "Szekszárdi" "Szekszárd")
    ("Szerencsi Tankerületi Központ" "Szerencsi TK" "Szerencsi" "Szerencs")
    ("Szigetszentmiklósi Tankerületi Központ" "Szigetszentmiklósi TK" "Szigetszentmiklósi" "Szigetszentmiklós")
    ("Szigetvári Tankerületi Központ" "Szigetvári TK" "Szigetvári" "Szigetvár")
    ("Szolnoki Tankerületi Központ" "Szolnoki TK" "Szolnoki" "Szolnok")
    ("Szombathelyi Tankerületi Központ" "Szombathelyi TK" "Szombathelyi" "Szombathely")
    ("Tamási Tankerületi Központ" "Tamási TK" "Tamási" "Tamási")
    ("Tatabányai Tankerületi Központ" "Tatabányai TK" "Tatabányai" "Tatabánya")
    ("Váci Tankerületi Központ" "Váci TK" "Váci" "Vác")
    ("Veszprémi Tankerületi Központ" "Veszprémi TK" "Veszprémi" "Veszprém")
    ("Zalaegerszegi Tankerületi Központ" "Zalaegerszegi TK" "Zalaegerszegi" "Zalaegerszeg")))


(defun init-db ()
  "Initialize *DB* according to *SCHEMA*."
  (drop-all-tables)
  ;; Create empty tables
  (dolist (table (schema-tables))
    (create-table table))
  ;; Fill up tks.
  (dolist (tk (mapcar #'first *tk-synonyms*))
    (insert-into 'tank_kozpontok '(tank_kozpont) t tk)))


;;; ----------------------------------------------------------------------
;;; Main


(defun start ()
  "'main'"
  nil)
