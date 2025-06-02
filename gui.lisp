;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Browser


(capi:define-interface browser ()
  ((dbview            :accessor dbview            :initarg  :dbview)
   (first-row         :accessor first-row         :initform 0)
   (virtual-position  :accessor virtual-position  :initform 0)
;   (previous-vpos     :accessor previous-vpos     :initform 0)
   (source-row-count  :accessor source-row-count  :initform 0)
   (header-height     :accessor header-height     :initarg  :header-height)
   (row-height        :accessor row-height        :initarg  :row-height)
   (visible-row-count :accessor visible-row-count :initform 0)
   (page-size         :accessor page-size         :initarg  :page-size)
   (page              :accessor page              :initarg  :data)
   (query             :accessor query             :initform nil))

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


; AKKOR MEGBÍZHATÓ, HA A LEKÉRDEZÉS MÉRETE NEM VÁLTOZIK.
; AZ LENNE AZ IDEÁLIS, HA A LEKÉRDEZÉS EREDMÉNYÉNEK ID OSZLOPA EGYBEN LEJÖNNE
; EGY HELYI ADATBÁZISBA, ÉS AZ ALPJÁN JELENNÉNEK MEG A BÖNGÉSZETT ADATOK.
; LEHETNE MANUÁLISAN FRISSÍTENI, DE OLYANKOR A KIJELÖLÉS ELVÉSZ!
(defmethod init-source-row-count ((obj browser))
  "Select the count of resulting rows."
  (with-db-context
    (let ((count (apply #'count/ (query obj))))
      (setf (source-row-count obj) count
            (capi:range-end (vscroll obj)) count))))


(defun update-virtual-position (interface)
  "Scale source row count according to vscroll slug position."
  (let ((pane (vscroll interface)))
    (setf (virtual-position interface)
          (* (- (source-row-count interface)
                (visible-row-count interface))
             (/ (capi:range-slug-start pane)
                (- (capi:range-end pane)
                   (capi:scroll-bar-page-size pane)))))

    (setf (capi:title-pane-text (disp interface))
          (format nil "~a   ~a   ~a   ~a   ~a"
                  (capi:range-slug-start pane)
                  (capi:range-end pane)
                  (capi:scroll-bar-page-size pane)
                  (virtual-position interface)
                  (page-fault-p interface)
                  ))
  ))


(defmethod page-fault-p ((obj browser))
  "Determine whether current virtual position is outside of page?"
  (with-slots (first-row virtual-position page-size visible-row-count) obj
    (not (<= first-row virtual-position
             (+ first-row page-size (- visible-row-count))))))


(defmethod load-page ((obj browser))
  "Load query data into PAGE."
  (with-db-context
    (setf (capi:collection-items (mclp obj))
          (apply #'select/ (append (query obj)
                                   (list :limit (page-size obj)
                                         :offset (first-row obj)))))))


(defmethod update-pages ((obj browser))
  "Refresh page upon page fault."
  (setf (first-row obj)
        (max 0 (- (virtual-position obj)
                  (round (/ (page-size obj) 2)))))
  (load-page obj))


(defmethod scroll-mclp ((obj browser))
  "When position is in page, scroll the list."
  (capi:scroll (mclp obj) :vertical :move
               (- (virtual-position obj)
                  (first-row obj))))


(defun handle-vscroll (interface &optional pane method position)
  "Update virtual position, check/handle page fault and scroll the list."
  (declare (ignore pane method position))
  (update-virtual-position interface)
  (when (page-fault-p interface)
    (update-pages interface))
  (scroll-mclp interface))


(defmethod resize-list-area ((obj browser))
  "Calculate row count upon resizing window, then call REFRESH-DATA."
  (let* ((pane-height (capi:with-geometry (mclp obj)
                        capi:%height%))
         (row-count   (floor (- pane-height (header-height obj)) (row-height obj))))
    (setf (visible-row-count obj) row-count
          (capi:scroll-bar-page-size (vscroll obj)) row-count)
    (handle-vscroll obj)))


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
                                          (resize-list-area interface))
            :dbview                   (view-columns view)
            :row-height               row-height
            :header-height            header-height
            :vscroll-callback         #'handle-vscroll
            :browser-own-scroll       nil;#'(lambda (interface pane method position)
                                         ; (wax:wg-msg "~a  ~a  ~a  ~a"
                                         ;             interface pane method position))
            )))
      (setf (query interface) (list (dbview interface))
            )
      (init-source-row-count interface)
      (load-page interface)
      interface))
)


#|
A következõ teendõ:

Tartsuk nyilván az elõzõ pozíciót, és a háttérben töltsük be az elõzõ és következõ lapot.

Mindhárom lap esetén külön szükséges nyilvántartani a kezdõsort.

A page-fault-p-nek mindhárom lapot néznie kell...
Sõt helyette legyen egy find-page ami visszaadja hogy melyik lapon van a keresett sor?

A mádik két lapból megnézni, melyk esik távolabb a v.sortól, és azt frissíteni a másik irányból.
|#


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
