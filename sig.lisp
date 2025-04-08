;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Globals


(defparameter *db-location* #P"//kozpfs/Homes/Cselovszkid/")
(defparameter *db-name* "sig.db")

(define-symbol-macro %dbfile%
  (merge-pathnames *db-name* *db-location*))

(defvar *db* nil)


#|;;; ----------------------------------------------------------------------
;;; Initialization

|#


;;; ----------------------------------------------------------------------
;;; Main


;(defun start ()
;  nil)


;;; ----------------------------------------------------------------------
;;; Sandbox


(defun test1 ()
  (with-open-database (*db* %dbfile%)
    (execute-to-list *db* "select id, user_name, age from users")))


(defun yyield (object)
  (let ((multi (multiple-value-list (yield object))))
    (nconc (list (first multi))
           (first (rest multi)))))

(defun sql (database statement)
  (apply #'execute-to-list database (yyield statement)))



(defparameter *file* "c:/Users/cselovszkid/kk.db")

(defun test2 ()
  (with-open-database (db *file*)
    (sql db (create-table :szemelyek
                ((szemely_id :type 'integer :primary-key t)
                 (nev :type 'string :not-null t)
                 (beosztas_id :type 'integer :not-null t)
                 (szervegys_id :type 'integer :not-null t))))
    (sql db (create-table :beosztasok
                ((beosztas_id :type 'integer :primary-key t)
                 (beosztas :type 'string :not-null t))))
    (sql db (create-table :szervezeti_egysegek
                ((szervegys_id :type 'integer :primary-key t)
                 (szervegys :type 'string :not-null t))))))

(defun test3 ()
  (with-open-database (db *file*)
    (format t "SZEMELYEK~%~a~%~%"
            (sql db (select (:szemely_id :nev :beosztas_id :szervegys_id)
                      (from :szemelyek))))
    (format t "BEOSZTASOK~%~a~%~%"
            (sql db (select (:beosztas_id :beosztas)
                      (from :beosztasok))))
    (format t "SZERVEZETIEGYSEGEK~%~a~%~%"
            (sql db (select (:szervegys_id :szervegys)
                      (from :szervezeti_egysegek))))))

(defun test4 ()
  (with-open-database (db *file*)
    (sql db (select (:nev :beosztas :szervegys)
              (from :szemelyek)
              (left-join :beosztasok :on (:= :szemelyek.beosztas_id :beosztasok.beosztas_id))
              (left-join :szervezeti_egysegek :on (:= :szemelyek.szervegys_id :szervezeti_egysegek.szervegys_id))))))

#|
  (sql a (insert-into :beosztasok
           (:beosztas)
           '(("Ügyintézõ") ("Referens") ("Fõosztályvezetõ") ("Gazdasági Vezetõ")
             ("Osztályvezetõ") ("Szakmai Vezetõ") ("Pikk") '("Bubi") '("Stüszi Vadász"))))

  (sql a (insert-into :szervezeti_egysegek
           (:szervegys)
           '(("Személyügyi Osztály") ("Belsõ Ellenõrzési Fõosztály") ("Büfé"))))

  (sql a (insert-into :szemelyek
           (:nev :beosztas_id :szervegys_id)
           '(("Margóka" 2 1)
             ("Bejáta" 1 2)
             ("Diszkójumurdzsák" 9 3)
             ("Andrea" 5 1)
             ("Weber nagyúr" 6 3))))
  |#








(defparameter *multitest-file* "//kozpfs/Org/Jogi és Személyügyi Fõosztály/Személyügyi Osztály/CsD/db.db")
(defparameter *timeout* 10000)

(defun multitest-init ()
  (with-open-database (db *multitest-file* :busy-timeout *timeout*)
    (sql db (create-table :teszt
                ((id :type 'integer :primary-key t)
                 (szoveg :type 'string :not-null t)
                 (szam :type 'integer :not-null t))))))

(defun multitest-insert (string-prefix)
  (let ((unitime (get-universal-time)))
    (with-open-database (db *multitest-file* :busy-timeout *timeout*)
      (sql db (insert-into :teszt
                (:szoveg :szam)
                (list (format nil "~a_~a" string-prefix unitime)
                      unitime))))
    unitime))

(defun multitest-dump ()
  (with-open-database (db *multitest-file* :busy-timeout *timeout*)
    (values
     (sql db (select (:szoveg :szam)
               (from :teszt)))
     (sql db (select (:id (:count :*)) (from :teszt))))))

(defparameter *multitest-iterations* 600)


(defun process (obj)
  (let ((prefix (concatenate 'string
                             (coerce (loop for i from 1 upto 5
                                           for c = (code-char (+ (random 24) 65))
                                           collecting c)
                                     'string)
                             "_")))
    (wax::with-progress-new ("Konkurrens INSERT" obj *multitest-iterations*)
      (dump obj "~a iteráció~%~%" *multitest-iterations*)
      (dotimes (i *multitest-iterations*)
        (dump obj "~a~%" (multitest-insert prefix))
        (pstep obj)
        (pabort obj))
      (multiple-value-bind (big small)
          (multitest-dump)
        (dump obj "~%~%~a~%~%Rekordok száma: ~a~%" big small)))))


(defun start ()
  (let ((obj (make-instance 'wax-script :execute-fn #'process)))
    (wax-execute obj :errorsink-on nil); t)
    ))
