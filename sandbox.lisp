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
    (wax::with-progress-new ("Konkurens INSERT" obj :limit *ctest-iterations*)
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

(defparameter *test-data-2* '("c:/Users/cselovszkid/common-lisp/sig/tesztadatok1.xlsx"
                              "c:/Users/cselovszkid/common-lisp/sig/tesztadatok2.xlsx"
                              "c:/Users/cselovszkid/common-lisp/sig/tesztadatok3.xlsx"))

(defparameter *test-data-3* '("c:/Users/cselovszkid/common-lisp/sig/tesztadatok_x.xlsx"))


(defun test01 ()
  (verify-statements (:execute t)
    (with-db-context

      (init-db)
      (let ((obj (make-instance 'wax-script :execute-fn #'import-xlsxs)))
        (dolist (file *test-data-3*)
          (add-data-source obj (intern (symbol-name (gensym)) :keyword) file))
        (wax-execute obj :errorsink-on nil))

#|      (select '(igenyles_id)
              :from 'igenylesek
              :left-join '((igenylesek szerv_egysegek szerv_egys_id)
                           (szerv_egysegek tank_kozpontok tank_kozpont_id))
              :where `(,(col 'tank_kozpont 'tank_kozpontok) = "Egri Tankerületi Központ"))|#
      
#|      (select-simple '(igenyles_id)
               :where '(tank_kozpont = "Egri Tankerületi Központ"))|#

#|      (select-simple '(telefon)
               :where '(email like "%@isi%"))|#

      )))
