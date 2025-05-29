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

(defun test01 ()
  (verify-statements (:execute t)
    (with-db-context

#|      (init-db)
      (let ((obj (make-instance 'wax-script :execute-fn #'import-xlsxs)))
        (dolist (file *test-data-2*)
          (add-data-source obj (intern (symbol-name (gensym)) :keyword) file))
        (wax-execute obj :errorsink-on nil))|#

#|      (select '(igenyles_id)
              :from 'igenylesek
              :left-join '((igenylesek szerv_egysegek szerv_egys_id)
                           (szerv_egysegek tank_kozpontok tank_kozpont_id))
              :where `(,(col 'tank_kozpont 'tank_kozpontok) = "Egri Tankerületi Központ"))|#
      
#|      (select/ '(igenyles_id)
               :where '(tank_kozpont = "Egri Tankerületi Központ"))|#

      (select/ '(telefon)
               :where '(email like "%@isi%"))

      )
    )
  )


;;; ----------------------------------------------------------------------
;;; GUI


(defun test02 ()
  "Display imported data"
  (with-db-context
    (let* ((view    (view :main))
           (headers (mapcar #'(lambda (label)
                                (list :title (import/ label)))
                            view))
           (data    (select/ view)))
      (capi:contain
       (make-instance 'capi:multi-column-list-panel
                      :columns headers
                      :items data
                      :title "Non-editable Spreadsheet"
                      :interaction :extended-selection
                      :item-print-functions #'(lambda (item)
                                                (if (member item '("NULL" nil) :test #'equal)
                                                  ""
                                                  item))
                      ;:filter t
                      )))))


(defun test03 ()
  "Display 100000 rows of random data"
  (let* ((count 5)
         (main (make-instance 'capi:multi-column-list-panel
                              :columns (loop for h from 0 below 5 collecting
                                             (list :title (random-alphanumeric-string 5)))
                              :items (loop for r from 0 below 10000 collecting
                                           (loop for i from 0 below 5 collecting
                                                 (random-alphanumeric-string 80)))
                              :title "Editable Spreadsheet"
                              :interaction :extended-selection
                              :column-function
                              #'(lambda (row)
#|                                  (if (zerop count)
                                    (list nil nil nil nil nil)
                                    (progn
                                      (decf count)
                                      row))|#
                                  (push (first row) h)
                                  (rest row)
                                  )
                              :item-print-functions
                              #'(lambda (item)
                                  (if (member item '(nil null))
                                    ""
                                    item))
                              :items-get-function
                              #'(lambda (seq idx) ; a tree-vel és a sor számával van meghívva, minden sor
                                  (cons idx (elt seq idx))
                                  )
                              :filter t)))
  (with-db-context
    (capi:contain main)
    main
    )))


(defun test04 ()
  "Display imported data"
  (with-db-context
    (let* ((*sqlfn* #'sql->sv)
           (view    (view :main))
           (headers (mapcar #'(lambda (label)
                                (list :title (import/ label)))
                            view))
           (data    (select/ view)))
      (capi:contain
       (make-instance 'capi:multi-column-list-panel
                      :columns headers
                      :items data
                      :title "Non-editable Spreadsheet"
                      :interaction :extended-selection
                      :items-get-function #'svref
                      :column-function #'(lambda (row)
                                           (coerce row 'list))
                      :item-print-functions #'(lambda (item)
                                                (if (member item '("NULL" nil) :test #'equal)
                                                  ""
                                                  item))
                      ;:filter t
                      )))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(capi:define-interface browser ()
  ()
  (:panes
   ;; Ide jönnek a szûrõk

   (upper-button
    capi:push-button
    :accessor upper-button
    :text "Felsõ gomb"
    :callback-type :interface
    :callback nil);(:initarg upper-button))

   (disp
    capi:title-pane
    :accessor disp
    :text "...")

   (ssheet
    capi:multi-column-list-panel
    :accessor             ssheet
    :columns              (:initarg headers)
    :items                (:initarg data)
;    :title                "Non-editable Spreadsheet"
    :interaction          :extended-selection
    :items-get-function   #'svref
;    :column-function      #'(lambda (row)
;                              (coerce row 'list))
    :item-print-functions #'(lambda (item)
                              (if (member item '("NULL" nil) :test #'equal)
                                ""
                                item))
    :horizontal-scroll    t;nil
    :vertical-scroll      :without-bar;nil
    :filter               nil
    )
   ;; Ide jönnek az import/export/kilépés gombok

   (lower-button
    capi:push-button
    :accessor lower-button
    :text "Alsó gomb"
    :callback-type :interface
    :callback nil);(:initarg lower-button))
   )
  (:layouts
   (upper capi:row-layout '(upper-button disp))
   (mid capi:column-layout '(ssheet))
   (lower capi:row-layout '(lower-button))
   (borders capi:column-layout '(upper lower))
   (default capi:column-layout '(upper mid lower))
   )
  (:default-initargs
   :display-state :normal
   :window-styles '(:resizable)
   :layout 'default
    :visible-min-width '(/ :screen-width 2)
    :visible-max-width :screen-width
    :visible-min-height '(/ :screen-height 2)
    :visible-max-height :screen-height
   ))


(defun report (interface x y w h)
  (setf (capi:title-pane-text (disp interface))
        (format nil "~a  ~a  ~a  ~a" x y w h)))




(defun screen-geometry (interface &optional (device-accessor #'first))
  (let ((screen (capi:element-screen interface)))
    (funcall device-accessor (capi:screen-internal-geometries screen))))


(defun maximize (interface &optional (device-accessor #'first))
  (destructuring-bind (x y width height)
      (screen-geometry interface device-accessor)
    (capi:execute-with-interface interface
     'capi:set-top-level-interface-geometry interface
     :x x :y y :width width :height height)))


(defun empty-data (length &optional (number-of-rows 1))
  (let ((results
         (loop for i from 0 below number-of-rows collecting
               (loop for j from 0 below length collecting
                     ""))))
    (coerce results 'simple-vector)))


(defun modify-data (pane data)
  (capi:execute-with-interface (capi:top-level-interface pane)
   #'(lambda ()
       (setf (capi:collection-items pane) data))))


(defun number-of-rows (pane &optional (i 1) (j 5))
  (let ((length    (length (slot-value pane 'capi::columns)))
        (height-i  nil)
        (height-j  nil)
        (interface (capi:top-level-interface pane))
        (borders   (make-instance 'browser :headers '(nil) :layout 'borders))
        (safety    80))
    (modify-data pane (empty-data length i))
    (capi:with-geometry pane (setf height-i capi:%height%))
    (modify-data pane (empty-data length j))
    (loop doing (capi:with-geometry pane (setf height-j capi:%height%))
          until (/= height-i height-j))
    (let* ((a (/ (- height-j height-i)
                 (- j i)))
           (n (- height-i (* i a)))
           (r nil)
           (s nil))
      ;; Calculating R
      (capi:display borders)
      (setf r (first (last (multiple-value-list
                            (capi:top-level-interface-geometry borders)))))
      (capi:destroy borders)
      ;; Calculating S
      (setf s (first (last (first (multiple-value-list (screen-geometry interface))))))
      (floor (/ (- s n r safety) a)))))

          


(defun test05 ()
  (with-db-context
    (let* ((*sqlfn* #'sql->sv)
           (view    (view :main))
           (headers (mapcar #'(lambda (label)
                                (list :title (import/ label)))
                            view))
           (data    (select/ view :where '(tank_kozpont = "Egri Tankerületi Központ")))
;           (data    (select/ view))
;           (data    (empty-data (length headers) 1))
           (main    (make-instance 'browser
                                   :headers headers
                                   :data data
                                   :layout 'default
                                   :geometry-change-callback 'report   ;   ::::-----)))))))
                                   ))
           )
      (capi:display main)
;      (maximize main)

;      (number-of-rows (ssheet main))

      )))
      
