;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Globals


(defparameter *db-location* #P"//kozpfs/Homes/Cselovszkid/")
(defparameter *db-name* "sig.db")

(define-symbol-macro %dbfile%
  (merge-pathnames *db-name* *db-location*))

(defvar *db* nil)


;;; ----------------------------------------------------------------------
;;; Initialize schema





#|
 Szuperduper, temp tábla import mûködik.
 Köv: tényleges séma létrehozása
 temp -> táblák import (minden egyszerre)
 lekérdezés táblákból és exportálás Excelbe
 Grafikus felület: böngészés, import/export gombok
 
 |#


;   INSERT INTO person (sex, age, name) VALUES ('male', 25, 'Eitaro Fukamachi'), ('female', 16, 'Miku Hatsune')>






;;; ----------------------------------------------------------------------
;;; Main


;(defun start ()
;  nil)
