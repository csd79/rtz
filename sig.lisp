;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Initialize database


(defun init-db (db)
  (drop-all-tables db)
  (dolist (table (schema-tables))
    (create-table db table)))


#|
    Szuperduper, temp tábla import mûködik.
    Köv: tényleges séma létrehozása
 temp -> táblák import (minden egyszerre)
 lekérdezés táblákból és exportálás Excelbe
 Grafikus felület: böngészés, import/export gombok

 |#

;;; ----------------------------------------------------------------------
;;; Main


(defun start ()
  nil)
