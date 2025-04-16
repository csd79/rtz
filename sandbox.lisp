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
    (drop-all-tables *db*)
    (create-table *db* 'teszt '((id integer primary key)
                                (szoveg text not null)
                                (szam integer)))))


(defun ctest-insert (prefix)
  (let ((unitime (get-universal-time)))
    (with-ctest-db
      (insert-into *db* 'teszt '(szoveg szam)
;      (insert-into *db* 'teszt 'szoveg
                   (format nil "~a_~a" prefix unitime)
                   unitime))
    unitime))

(defun ctest-dump ()
  (with-ctest-db
    (values
     (dump-table 'teszt *db*)
     (number-of-rows 'teszt *db*))))
;     (sql->list *db* "select szoveg, count(*) from teszt"))))

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
        (pabort obj))
      (multiple-value-bind (dump number-of-rows)
          (ctest-dump)
;        (dump obj "~%~%~a~%~%Rekordok száma: ~a~%" big (second (first small))))))
        (dump obj "~%~%~a~%~%Rekordok száma: ~a~%" dump number-of-rows))))
  (with-ctest-db
    (table-info 'teszt *db*)))

(defun ctest-start ()
  (let ((obj (make-instance 'wax-script :execute-fn #'process)))
    (wax-execute obj :errorsink-on nil)))


;;; ----------------------------------------------------------------------
;;; Random


#|
(defparameter *test-data-1* "c:/Users/cselovszkid/common-lisp/sig/tesztadatok.xlsx")


(defun test01 ()
  (with-db-context
    (init-db *db*)
    (single-xlsx->new-temp *db* *test-data-1* "denes")
    (dolist (table (table-list *db*))
      (dump-table table *db*))
    ))
|#
