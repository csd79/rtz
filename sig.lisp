;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Initialize database


(defun init-db (db)
  (drop-all-tables db)
  (dolist (table (schema-tables))
    (create-table db table)))


;;; ----------------------------------------------------------------------
;;; Main


(defun start ()
  nil)
