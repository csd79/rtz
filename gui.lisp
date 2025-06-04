;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Browser


(capi:define-interface browser ()
  (
   (dbview            :accessor dbview            :initarg  :dbview)
   (header-height     :accessor header-height     :initarg  :header-height)
   (row-height        :accessor row-height        :initarg  :row-height)

   (query             :accessor query             :initarg  :query)
   (id-temp-table     :accessor id-temp-table     :initform "")

   (source-row-count  :accessor source-row-count  :initform 0)

   (page-first-row    :accessor page-first-row    :initform 0)
   (page-size         :accessor page-size         :initarg  :page-size)
   (page              :accessor page              :initarg  :data)

   (visible-row-count :accessor visible-row-count :initform 0)

   (vpos              :accessor vpos              :initform 0)
   )

  (:panes
   ;; ...filtering...

   (upper-button
    capi:push-button
    :accessor upper-button
    :text "Felsõ gomb"
    :callback-type :interface
    :callback (:initarg :upper-button))

   (disp
    capi:title-pane
    :accessor disp
    :text "...")

   (mclp
    capi:multi-column-list-panel
    :accessor             mclp
    :columns              (:initarg headers)
    :items                (:initarg data)
    :interaction          :extended-selection
    :items-get-function   #'aref
    :item-print-functions #'(lambda (item)
                              (cond ((numberp item) (format nil "~a" item))
                                    ((member item '("NULL" nil) :test #'equal)
                                     "")
                                    (t item)))
    :horizontal-scroll    t
    :vertical-scroll      (:initarg :browser-vertical-scroll)
    :scroll-callback      (:initarg :browser-own-scroll)
    :filter               nil)

   (vscroll
    capi:scroll-bar
    :accessor vscroll
    :start 0
    :end (:initarg :vscroll-max)
    :orientation :vertical
    :callback (:initarg :vscroll-callback))

   ;; ...import/export/exit...

   (lower-button
    capi:push-button
    :accessor lower-button
    :text "Alsó gomb"
    :callback-type :interface
    :callback nil));(:initarg lower-button)))

   (:layouts
    (upper capi:row-layout '(upper-button disp))
    (mid capi:row-layout '(mclp vscroll))
    (lower capi:row-layout '(lower-button))
    (borders capi:column-layout '(upper lower))
    (default capi:column-layout '(upper mid lower)))

   (:default-initargs
    :display-state :normal
    :window-styles '(:resizable)
    :layout 'default
    :visible-min-width '(/ :screen-width 2)
    :visible-max-width :screen-width
    :visible-min-height '(/ :screen-height 2)
    :visible-max-height :screen-height
    :browser-vertical-scroll :without-bar
    :page-size 200 ;50000
    :data nil
    :vscroll-max 100
    :upper-button nil
    :query '()
    ))


(defun calculate-row-height ()
  "Calculate the pixel height of a single data row and the array header."
  (flet ((height (interface)
           (let ((result nil))
             (capi:display interface)
             (capi:with-geometry (mclp interface) (setf result capi:%height%))
             (capi:destroy interface)
             result))
         (make-interface (number-of-rows)
           (make-instance 'browser
                          :headers '((:title "."))
                          :data (coerce (loop for i from 0 below number-of-rows
                                              collecting '(".."))
                                        'vector)
                          :browser-vertical-scroll nil)))
    (let* ((hgt1 (height (make-interface 1)))
           (hgt  (- (height (make-interface 2)) hgt1))
           (hhgt (- hgt1 hgt)))
      (values hgt hhgt))))


;;; Init 1 --------------------------------


(defmethod query-tempid ((obj browser))
  "Refresh ID temp table."
  (with-db-context
    (with-slots (id-temp-table) obj
      ;; Delete any existing temporary id table.
      (unless (string= id-temp-table "")
        (drop-table id-temp-table))
      ;; Create new temporary table.
      (setf id-temp-table (unique-table-name (user-token)))
      (apply #'select-simple-id-into-temp
             (list (view-id (dbview obj)))
             (append (query obj)
                     (list :temp id-temp-table))))))

(defmethod init-paging ((obj browser))
  "Find the number of rows in query, set it to both slot and vscroll bar range.
   Also set relative pos to 0."
  (with-db-context
    (let ((count (first
                  (elt (funcall *sqlfn* (format nil "select count(~a) from ~a"
                                                (view-id (dbview obj))
                                                (id-temp-table obj)))
                       0))))
      (setf (source-row-count obj) count
            (capi:range-end (vscroll obj)) count
            (vpos obj) 0
            (page-first-row obj) 0
            ))))



(defmethod load-page ((obj browser))
  "Load query data into PAGE."
  (with-db-context
    (with-slots (dbview) obj
      (setf (capi:collection-items (mclp obj))
            (apply #'select-simple-by-temp
                   (append (list (view-columns dbview))
                           (query obj)
                           (list :temp (id-temp-table obj)
                                 :id   (view-id dbview)
                                 :limit (page-size obj)
                                 :offset (page-first-row obj)
                                 :order-by (view-order dbview))))))))

(defmethod init1 ((obj browser))
  (query-tempid obj)
  (init-paging obj)
  (load-page obj))


;;; Init 2 --------------------------------


(defmethod resize-list-area ((obj browser))
  "Calculate row count upon resizing window, then call REFRESH-DATA."
  (let* ((pane-height (capi:with-geometry (mclp obj)
                        capi:%height%))
         (row-count   (floor (- pane-height (header-height obj)) (row-height obj))))
    (setf (visible-row-count obj) row-count
          (capi:scroll-bar-page-size (vscroll obj)) row-count)
    (handle-vscroll obj)
    ))

(defparameter *min-slug-prop* 1/15)

#|(defmethod init-vscroll ((obj browser))
  "Init vscroll range & slug size."
  (setf g 'init-vscroll)
  (with-slots (source-row-count visible-row-count) obj
    (let ((range-end nil) (slug-end nil))
      (cond
       ;; If all rows fit on the screen
       ((<= source-row-count visible-row-count)
        (setf range-end 1
              slug-end  1))
       ;; If slug slize is larger than *MIN-VSLUG-SIZE*
       ((<= *min-vslug-size* (/ source-row-count visible-row-count))
        (setf range-end source-row-count
              slug-end  visible-row-count))
       ;; Otherwise
       (t (setf range-end (round (* *min-vslug-size* source-row-count) visible-row-count)
;                slug-end  *min-vslug-size*)))
                slug-end  (round source-row-count *min-vslug-size*))))
      ;; Actual assignments:
      (setf (capi:range-end (vscroll obj))        range-end
            (capi:range-slug-start (vscroll obj)) 0
            (capi:range-slug-end (vscroll obj))   slug-end))))|#
(defmethod init-vscroll ((obj browser))
  "Init vscroll range & slug size."
  (with-slots (source-row-count visible-row-count) obj
    (let* ((scroll-steps (max (- source-row-count visible-row-count) 0))
           (slug-prop    (min (/ visible-row-count source-row-count) 1))
           (slug-prop*   (max slug-prop *min-slug-prop*))
           (slug-size    (round (* source-row-count slug-prop*)))
           (range-end    (+ scroll-steps slug-size))
;           (position     (round (* source-row-count (relative-vpos obj))))
           )
      (setf ;(relative-vpos obj)                   0
            (capi:range-end        (vscroll obj)) range-end
            (capi:range-slug-start (vscroll obj)) 0
            (capi:range-slug-end   (vscroll obj)) slug-size)
      (setf g (list :scroll-steps scroll-steps :slug-prop* slug-prop*
                    :slug-size slug-size :range-end range-end
                    :slug-start (capi:range-slug-start (vscroll obj))
                    :slug-end (capi:range-slug-end   (vscroll obj))
                    :page-first-row (page-first-row obj)
                    ))
      )))
    

  
(defmethod init2 ((obj browser))
  (resize-list-area obj)
  (init-vscroll obj)
  (capi:redisplay-interface obj)
  )


;;; vscroll -------------------------------


(defun update-vpos (interface)
  "Scale source row count according to vscroll slug position."
  (let ((pane (vscroll interface)))
    (setf (vpos interface)
          (capi:range-slug-start pane))
    ;; nice info in the window, but delete it eventually;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (setf (capi:title-pane-text (disp interface))
          (format nil "source-row-count ~a; visible ~a; range-end ~a; relative-vpos ~a; slug-start ~a; slug-end ~a; page fault? ~a"
                  (source-row-count interface)
                  (visible-row-count interface)
                  (capi:range-end pane)
;                  (capi:scroll-bar-page-size pane)
                  (float (vpos interface))
                  (capi:range-slug-start pane)
                  (capi:range-slug-end pane)
                  (page-fault-p interface)
                  ))
  ))

(defmethod page-fault-p ((obj browser))
  "Determine whether current virtual position is outside of page?"
  (with-slots (page-first-row page-size visible-row-count) obj
    (not (<= page-first-row
             (vpos obj)
             (+ page-first-row page-size (- visible-row-count))))))

(defmethod update-pages ((obj browser))
  "Refresh page upon page fault."
  (setf (page-first-row obj)
        (max 0 (- (vpos obj)
                  (round (/ (page-size obj) 2)))))
  (load-page obj))

(defmethod scroll-mclp ((obj browser))
  "When position is in page, scroll the list."
  (capi:scroll (mclp obj) :vertical :move
               (- (vpos obj)
                  (page-first-row obj))))

(defun handle-vscroll (interface &optional pane method position)
  "Update virtual position, check/handle page fault and scroll the list."
  (declare (ignore pane method position))
  (update-vpos interface)
  (when (page-fault-p interface)
    (update-pages interface))
  (scroll-mclp interface))


;;; Create browser ------------------------


(defparameter *tks* '(nil "%Egri%" "%Baja%" "%Debrecen%" "%Külsõ-Pest%"))
(defparameter *tksi* 0)
(defun next-query ()
  (let* ((element (nth *tksi* *tks*))
         (result (if element
                   `(:where (tank_kozpont like ,element))
                   '())))
    (if (< *tksi* (1- (length *tks*)))
      (incf *tksi*)
      (setf *tksi* 0))
    result))



(defun make-browser (view)
  "Create & initialize browser window."
  (multiple-value-bind (row-height header-height)
      (calculate-row-height)
    (let ((interface
           (make-instance
            'browser
            :headers                  (mapcar #'(lambda (label)
                                                  (list :title label))
                                              (view-labels view))
            :geometry-change-callback #'(lambda (interface x y w h)
                                          (declare (ignore x y w h))
;                                          (resize-list-area interface)
                                          (init2 interface)
                                          (handle-vscroll interface)
                                          )
            :dbview                   view
            :row-height               row-height
            :header-height            header-height
            :vscroll-callback         #'handle-vscroll
            :browser-own-scroll       nil;#'(lambda (interface pane method position)
                                         ; (wax:wg-msg "~a  ~a  ~a  ~a"
                                         ;             interface pane method position))
            :upper-button             #'(lambda (interface)
                                          (setf (query interface)
                                                (next-query))
                                          (init1 interface)
                                          (init2 interface)
                                          (handle-vscroll interface)
                                          )
            )))
      (init1 interface)
      interface))
)

(defmethod interface-display :after ((obj browser))
  (init2 obj))
  
  


#|
TEENDÕK:

A listában történõ görgetõ események visszavetítése a vscrollra.

Kiválasztások követése!?!?!

Legyen dinamikus lapozás: a lapok legyenek egy listában, és mindegyiknek legyen saját kezdõsora/kijelöltje.
    A lapok között legyen egy elsõdleges, amiben a görgetés történik, és legyen n db. másodlagos,
        amelyk mind más-más területet fednek le az elsõdleges elõtt/után.
    Görgetési eseménykor meg kell nézni h. az elsõdleges lapon vagyunk-e (primary-page-fault-p).
        Ha igen. görgetés.
    Ha nem, megnézni hogy a virtuális sor megtalálható-e valamelyik lapon.
    Ha igen, legyen az az elsõdleges lap, és a többibõl eldobni amelyik már nem releváns és
        feltölteni egy szükséges lappal (mindez a háttérben).
    Ha nem, teljesen újratölteni a lapokat.
|#


;;; ----------------------------------------------------------------------
;;; Sandbox


(defun test06 ()
  "Browser"
  (let ((browser (make-browser :main)))
    (capi:display browser)
    (init2 browser)
    ))


(defun test07 ()
  "Count selection"
  (with-db-context
    (count-simple (view-columns :main))))
