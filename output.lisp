;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Paging


#|
We execute a SELECT query where only IDs are collected. Then SELECT n number of rows using:
WHERE id in (1,2,3)

HOW CAN WE SELECT BY FOREIGN VALUES???

|#

(defparameter *page-size* 100)


(defun select-ids (table where)
  (let ((primary (primary-key table)))
    (select (list primary) :from (list table 'szerv_egysegek 'tank_kozpontok) :where where)))


;;; ----------------------------------------------------------------------
;;; db -> import columns


