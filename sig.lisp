;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Globals


(defparameter *db-location* #P"//kozpfs/Homes/Cselovszkid/")
(defparameter *db-name* "sig.db")
(define-symbol-macro %dbfile% (merge-pathnames *db-name* *db-location*))

(defparameter *db* nil)
(defparameter *timeout* 10000)
(defparameter *auto-close* t)


;;; ----------------------------------------------------------------------
;;; Initialize schema


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


;(defun start ()
;  nil)


;;; ----------------------------------------------------------------------
;;; Sandbox


(defparameter *test-data-1* "c:/Users/cselovszkid/common-lisp/sig/tesztadatok.xlsx")


(defun test01 ()
  (with-db-context
    (init-db *db*)
    (single-xlsx->new-temp *db* *test-data-1* "denes")
    (dolist (table (table-list *db*))
      (dump-table table *db*))
    ))

