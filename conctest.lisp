;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Concurrency test


(defparameter *conctest-file* "//kozpfs/Org/Jogi és Személyügyi Fõosztály/Személyügyi Osztály/CsD/db.db")

(defun conctest-init ()
  (with-open-database (db *conctest-file* :busy-timeout *timeout*)
    (create-table db 'teszt '((:lit id integer primary key)
                              (:lit szoveg string not null)
                              (:lit szam integer not null)))))

(defun conctest-insert (string-prefix)
  (let ((unitime (get-universal-time)))
    (with-open-database (db *conctest-file* :busy-timeout *timeout*)
      (insert-into db 'teszt '(szoveg szam)
                   (list (format nil "~a_~a" string-prefix unitime)
                         unitime)))
    unitime))

(defun conctest-dump ()
  (with-open-database (db *conctest-file* :busy-timeout *timeout*)
    (values
     (sql db "select szoveg, szam from teszt")
     (sql db "select id, count(*) from teszt"))))

(defparameter *conctest-iterations* 300)

(defun process (obj)
  (let ((prefix (concatenate 'string
                             (coerce (loop for i from 1 upto 5
                                           for c = (code-char (+ (random 24) 65))
                                           collecting c)
                                     'string)
                             "_")))
    (wax::with-progress-new ("Konkurrens INSERT" obj *conctest-iterations*)
      (dump obj "~a iteráció~%~%" *conctest-iterations*)
      (dotimes (i *conctest-iterations*)
        (dump obj "~a~%" (conctest-insert prefix))
        (pstep obj)
        (pabort obj))
      (multiple-value-bind (big small)
          (conctest-dump)
        (dump obj "~%~%~a~%~%Rekordok száma: ~a~%" big small)))))

(defun conctest-start ()
  (let ((obj (make-instance 'wax-script :execute-fn #'process)))
    (wax-execute obj :errorsink-on nil)))
