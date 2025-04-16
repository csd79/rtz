;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


#|
;;; ----------------------------------------------------------------------
;;; Initialize database


(defun init-db (db)
  (let ((to-drop (table-list db))
        (tables  (list-schema-table-names)))
    ;; Deleting existing tables
    (dolist (table to-drop)
      (sql db "drop table ~a" table))
    ;; Create tables
    (dolist (table tables)
      (create-table db table
                    (mapcar #'(lambda (column)
                                (nconc (list :lit column)
                                        (column-description table column)))
                            (list-schema-table-columns table))))))

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
|#
