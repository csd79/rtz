;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Initialize database


(defun init-db ()
  "Initialize *DB* according to *SCHEMA*."
  (drop-all-tables)
  (dolist (table (schema-tables))
    (create-table table)))


;;; ----------------------------------------------------------------------
;;; Main


(defun start ()
  "'main'"
  nil)
