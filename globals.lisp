;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; Global parameters


(defparameter *appdir* "rtz")
(defparameter *independent-exe* nil)

(defparameter *db-location* #P"//kozpfs/Org/Jogi és Személyügyi Fõosztály/Személyügyi Osztály/CsD/rtz/")
(defparameter *db-name* "rtz.db")
(define-symbol-macro %dbfile% (merge-pathnames *db-name* *db-location*))

(defparameter *db* nil)
(defparameter *timeout* 10000)
(defparameter *auto-close* t)

(defparameter *rows-per-statement* 10)

(defparameter *locking-timeout* 10)
(defparameter *page-size* 100) ; 5000

(defparameter *vscroll-listener-sleep* 0.3)


;;; ----------------------------------------------------------------------
;;; Types


(defun sequencep (value)
  "T if VALUE is of type sequence."
  (typep value 'sequence))


(defun seq-of-strings-p (value)
  "T if VALUE is a sequence of strings."
  (and value
       (sequencep value)
       (every #'identity (mapcar #'stringp (coerce value 'list)))))
(deftype seq-of-strings () '(satisfies seq-of-strings-p))


(defun seq-of-seqs-p (value)
  "T if VALUE is a sequence of sequences."
  (and value
       (sequencep value)
       (every #'identity (mapcar #'sequencep (coerce value 'list)))))
(deftype seq-of-seqs () '(satisfies seq-of-seqs-p))


(defun stringp-or-symbolp (value)
  "T if VALUE is either a string or a symbol."
  (or (stringp value)
      (symbolp value)))


(defun seq-of-strings-or-symbols-p (value)
  "T if VALUE is a sequence of strings or symbols."
  (and value
       (sequencep value)
       (every #'identity (mapcar #'stringp-or-symbolp
                                 (coerce value 'list)))))
(deftype seq-of-strings-or-symbols ()
  '(satisfies seq-of-strings-or-symbols-p))


(defun seq-of-strings-symbols-or-numbers-p (value)
  "T if VALUE is a sequence of strings, symbols or numbers."
  (and value
       (sequencep value)
       (every #'(lambda (element)
                  (or (stringp-or-symbolp element)
                      (numberp element)))
              (coerce value 'list))))
(deftype seq-of-strings-symbols-or-numbers ()
  '(satisfies seq-of-strings-symbols-or-numbers-p))


(defun seq-of-seqs-of-strings-or-symbols-p (value)
  "T if VALUE is a sequence of sequences of strings or symbols."
  (and value
       (sequencep value)
       (every #'identity (mapcar #'seq-of-strings-or-symbols-p
                                 (coerce value 'list)))))
(deftype seq-of-seqs-of-strings-or-symbols ()
  '(satisfies seq-of-seqs-of-strings-or-symbols-p))


(defun value-list-p (list)
  (eq (first list) :vals))
(deftype value-list ()
  "A string of elements separated by commas, enclosed in parenthesis."
  '(and list (not null) (satisfies value-list-p)))


(defun enclosed-value-list-p (list)
  (eq (first list) :@vals))
(deftype enclosed-value-list ()
  "A string of elements separated by commas."
  '(and list (not null) (satisfies enclosed-value-list-p)))



;;; ----------------------------------------------------------------------
;;; TKs


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
