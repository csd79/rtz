;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Browser


#|
(capi:define-interface browser ()
  ((data-limit    :accessor data-limit    :initarg :data-limit)
   (dbview        :accessor dbview        :initarg :dbview)
   (row-height    :accessor row-height    :initarg :row-height)
   (header-height :accessor header-height :initarg :header-height)
   (row-count     :accessor row-count     :initform 1)
   (first-row     :accessor first-row     :initform 0)
   (data-count    :accessor data-count    :initform nil)
   (data-over     :accessor data-over     :initarg :data-main)
   (data-main     :accessor data-main     :initarg :data-main)
   (data-under    :accessor data-under    :initarg :data-main)
   (selection     :accessor selection     :initform '()))

  (:panes
   ;; ...filtering...

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
    (mid capi:row-layout '(ssheet vscroll))
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
    :data-limit 50000))


(defun calculate-row-height ()
  "Calculate the pixel height of a single data row and the array header."
  (flet ((height (interface)
           (let ((result nil))
             (capi:display interface)
             (capi:with-geometry (ssheet interface) (setf result capi:%height%))
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


;(defun dbselect (offset count &optional (where nil))
(defmethod dbselect ((obj browser))
  "Select fresh data from db for GUI."
  (with-db-context
    ;; JELENLEG CSAK LEKÉRDEZI AZ EGÉSZ SZART.
    (select/ (dbview obj))))


(defmethod refresh-data ((obj browser))
  "Refresh data caches upon scrolling/resizing."
  (unless (data-main obj)
    (setf (data-main obj)
          (dbselect obj)))
  ;; Mintha nem történt volna mozgás:
  (setf (capi:collection-items (ssheet obj))
        ;; Új displaced tömb a DATA-MAIN elejétõl
;        (make-array (row-count obj)
        (make-array (array-dimension (data-main obj) 0)
                    :displaced-to (data-main obj)
                    :displaced-index-offset (first-row obj))))


(defmethod resize-data-area ((obj browser))
  "Calculate row count upon resizing window, then call REFRESH-DATA."
  (let* ((pane-height (capi:with-geometry (ssheet obj)
                        capi:%height%))
         (row-count   (floor (- pane-height (header-height obj)) (row-height obj))))
    (setf (row-count obj) row-count))
  (refresh-data obj))


(defun make-browser (view)
  "Create & initialize browser window."
  (multiple-value-bind (row-height header-height)
      (calculate-row-height)
    (make-instance 'browser
                   :headers (mapcar #'(lambda (label)
                                        (list :title label))
                                    (view-labels view))
                   :data-main nil
                   :geometry-change-callback #'(lambda (interface x y w h)
                                                 (declare (ignore x y w h))
                                                 (resize-data-area interface))
                   :dbview (view-columns view)
                   :row-height row-height
                   :header-height header-height
                   :data-limit 200
                   :vscroll-callback
;                   ;; Jerky slow scrolling withing one page
;                   #'(lambda (interface pane method position)
;                       (setf (capi:title-pane-text (disp interface))
;                             (format nil "~a" (list method position)))
;                       (setf (first-row interface) position)
;                       (refresh-data interface))
;                   ;; Various infos
;                   #'(lambda (interface pane method position)
;                       (setf (capi:title-pane-text (disp interface))
;                             (format nil "~a ~a ~a"
;                                     (mapcar #'(lambda (fn)
;                                                 (funcall fn pane))
;                                             (list
;                                              #'capi:range-start
;                                              #'capi:range-end
;                                              #'capi:range-slug-start
;                                              #'capi:range-slug-end
;                                              #'capi:range-callback
;                                              #'capi:range-orientation))
;                                     method
;                                     position)))
;                                      ))))
                   #'(lambda (interface pane method position)
                       (declare (ignore pane method))
                       (setf (capi:title-pane-text (disp interface))
                             (format nil "VSCROLL: ~a" position))
                       (capi:scroll (ssheet interface) :vertical :move position))

                   :browser-own-scroll
;                   #'(lambda (interface pane method position)
;                       (declare (ignore pane))
;                       (setf (capi:title-pane-text (disp interface))
;                             (format nil "OWN: ~a ~a" method position)))
                   )))


;;; ----------------------------------------------------------------------
;;; Sandbox


(defun test06 ()
  "Browser"
  (let ((browser (make-browser :main)))
    (capi:display browser)))


(defun test07 ()
  "Count selection"
  (with-db-context
    (count/ (view-columns :main))))
|#


;;; AZ ALÁBBI SZART A CHATGPT PROGRAMOZTA


#|(defparameter *ds*
  (coerce (loop for i from 0 below 1000 collecting
                (list i (* 5 i)))
          'simple-vector))


(defparameter *page-size* 100)


(defun get-total-item-count (data-source)
  (array-dimension data-source 0))


(defun get-data-range (data-source start end)
  (let ((result (make-array *page-size* :initial-element nil)))
    (loop for s from start below end
          for d from 0
          doing (setf (aref result d) (aref data-source s)))
    result))


(defclass virtual-scroll-list-panel (capi:column-layout)
  ((list-panel       :accessor          list-panel)
   (loaded-range     :initform          (cons 0 0)   :accessor           loaded-range) ; (start . end)
   (visible-range    :initform          (cons 0 0)   :accessor           visible-range)
   (total-items      :initform          0            :accessor           total-items)
   (page-size        :initform          *page-size*  :accessor           page-size)
   (data-source      :initarg           :data-source :accessor           data-source)
   (scroll-position  :initform          0            :accessor           scroll-position))
  (:default-initargs :visible-min-width 400          :visible-min-height 300))


;; Example data source interface
;(defgeneric get-total-item-count (data-source))
;(defgeneric get-data-range (data-source start end))


(defun load-data (panel start end)
  (let ((new-data (get-data-range (data-source panel) start end)))
    (capi:apply-in-pane-process
     (list-panel panel)
     (lambda ()
       ;; This is simplified - you'll need to manage the collection properly
       (setf (capi:collection-items (list-panel panel))
             new-data)))))
;             (append (capi:collection-items (list-panel panel))
;                     new-data))))))


(defun initialize-data (panel)
  ;; Get total item count from data source
  (setf (total-items panel) (get-total-item-count (data-source panel)))
  ;; Load initial data
  (load-data panel 0 (page-size panel)))


(defun check-load-more-data (panel)
  (let* ((visible-start (floor (* (scroll-position panel) (total-items panel))))
         (visible-end (+ visible-start (page-size panel)))
         (loaded-start (car (loaded-range panel)))
         (loaded-end (cdr (loaded-range panel)))
         (buffer-size (floor (page-size panel) 2)))
    ;; Check if we need to load more data at the bottom
    (when (> visible-end (- loaded-end buffer-size))
      (let ((new-end (min (total-items panel) 
                         (+ loaded-end (page-size panel)))))
        (when (> new-end loaded-end)
          (load-data panel loaded-end new-end)
          (setf (cdr (loaded-range panel)) new-end)))
    ;; Check if we need to load more data at the top
    (when (< visible-start (+ loaded-start buffer-size))
      (let ((new-start (max 0 (- loaded-start (page-size panel)))))
        (when (< new-start loaded-start)
          (load-data panel new-start loaded-start)
          (setf (car (loaded-range panel)) new-start)))))))


(defun handle-scroll (pane scroll-type position panel)
  (declare (ignore pane scroll-type))
  (setf (scroll-position panel) position)
  (check-load-more-data panel))


(defmethod initialize-instance :after ((panel virtual-scroll-list-panel) &key)
  (let ((list (make-instance 'capi:multi-column-list-panel
                             :columns                       '((:title "Col 1")
                                                              (:title "Col 2"))
                             :vertical-scroll               :without-bar ;t
;                             :vertical-scroll-callback      'handle-scroll
                             :scroll-callback              'handle-scroll
;                             :vertical-scroll-callback-data panel
                             :visible-min-height            200)))
    (setf (list-panel panel) list)
    (capi:apply-in-pane-process 
     list
     (lambda () 
       (setf (capi:layout-description panel) (list list))))
    (initialize-data panel)))


(defun scs ()
  (let* ((list    (make-instance 'virtual-scroll-list-panel :data-source *ds*))
         (vscroll (make-instance 'capi:scroll-bar
;                                 :accessor 'vscroll
                                 :orientation :vertical
                                 :callback #'(lambda (interface pane method position)
                                               (capi:scroll (list-panel list)
                                                            :vertical :move
                                                            position
;                                                            (* position (/ (total-items list)
;                                                                           100))
                                                            )))))
    (capi:contain
     (make-instance
      'capi:row-layout
      :description
      (list (list-panel list)
            vscroll
            )))))|#
          
                                        

;;; ----------------------------------------------------------------------




(defparameter *ds*
  (coerce (loop for i from 0 below 1000 collecting
                (list i (* 5 i)))
          'simple-vector))

(defparameter *page-size* 100)


(defclass virtual-multi-column-list-panel (capi:column-layout)
  ((mclp             :accessor mclp             :initform nil)
   (virtual-position :accessor virtual-position :initform 0)
   (virtual-size     :accessor virtual-size     :initform 0)
   (data-source      :accessor data-source      :initarg  :data-source)
   (vscroll          :accessor vscroll          :initform nil)))


(defmethod load-data ((pane virtual-multi-column-list-panel


(defmethod initialize-instance :after ((pane virtual-multi-column-list-panel) &rest mclp-args)
  (let ((mclp (apply #'make-instance 'capi:multi-column-list-panel
                     :vertical-scroll :without-bar
;                     :scroll-callback 'handle-scroll
                     mclp-args)))
    (setf (mclp pane) mclp
          (virtual-size pane) (array-dimension (data-source pane) 0)
          (vscroll pane) (make-instance
                          'capi:scroll-bar
                          :orientation :vertical
                          :callback #'(lambda (i p m position)
                                        (declare (ignore i p m))
                                        (setf (virtual-position pane)
                                              position))))))


(defun test08 ()
  (let ((vmclp (make-instance 'virtual-multi-column-list-panel :data-source *ds*)))
    (capi:contain
     (make-instance 'capi:row-layout
                    :description
                    (list (mclp vmclp) (vscroll vmclp))))))

