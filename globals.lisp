;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Globals


(defparameter *appdir* "sig")
(defparameter *independent-exe* nil)

(defparameter *db-location* #P"//kozpfs/Org/Jogi és Személyügyi Fõosztály/Személyügyi Osztály/CsD/sig/")
(defparameter *db-name* "sig.db")
(define-symbol-macro %dbfile% (merge-pathnames *db-name* *db-location*))

(defparameter *db* nil)
(defparameter *timeout* 10000)
(defparameter *auto-close* t)

(defparameter *rows-per-statement* 10)

(defparameter *locking-timeout* 10)
(defparameter *page-size* 100) ; 5000

(defparameter *vscroll-listener-sleep* 0.3)
