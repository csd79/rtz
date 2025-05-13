;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Concurrency test


(defparameter *ctest-iterations* 50)

(defmacro with-ctest-db (&body body)
  `(let ((*db-location* #P"//kozpfs/Org/Jogi és Személyügyi Fõosztály/Személyügyi Osztály/CsD/")
         (*db-name* "db.db"))
     (with-db-context
       ,@body)))

(defun ctest-init ()
  (with-ctest-db
    (drop-all-tables)
    (create-table 'teszt '((id integer primary key)
                           (szoveg text not null)
                           (szam integer)))))

(defun ctest-insert (prefix)
  (let ((unitime (get-universal-time)))
    (with-ctest-db
      (insert-into 'teszt '(szoveg szam) nil
                   (format nil "~a_~a" prefix unitime)
                   unitime))
    unitime))

(defun ctest-dump ()
  (with-ctest-db
    (values
     (dump-table 'teszt)
     (number-of-rows 'teszt))))

(defun ctest-info ()
  (with-ctest-db 
    (db-info)
    (table-info 'teszt)))

(defun process (obj)
  (let ((prefix (concatenate 'string
                             (coerce (loop for i from 1 upto 5
                                           for c = (code-char (+ (random 24) 65))
                                           collecting c)
                                     'string)
                             "_")))
    (wax::with-progress-new ("Konkurens INSERT" obj *ctest-iterations*)
      (dump obj "~a iteráció~%~%" *ctest-iterations*)
      (dotimes (i *ctest-iterations*)
        (dump obj "~a~%" (ctest-insert prefix))
        (pstep obj)
        (pabort obj)))))

(defun ctest ()
  ;; Initialisation
  (ctest-init)
  ;; Run import process
  (let ((obj (make-instance 'wax-script :execute-fn #'process)))
    (wax-execute obj :errorsink-on nil))
  ;; Dump db contents
  (multiple-value-bind (dump number-of-rows)
      (ctest-dump)
    (format t "~%~%~a~%~%Rekordok száma: ~a~%" dump number-of-rows))
  ;; DB info
  (ctest-info))


;;; ----------------------------------------------------------------------
;;; Import


(defparameter *test-data-1* "c:/Users/cselovszkid/common-lisp/sig/tesztadatok.xlsx")


(defun test01 ()
;  (verify-statements (:execute t)
    (with-db-context
      (init-db)
      (let ((obj (make-instance 'wax-script :execute-fn #'import-xlsx)))
        (add-data-source obj :import *test-data-1*)
        (wax-execute obj :errorsink-on nil))))
;  )
