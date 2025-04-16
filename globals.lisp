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
