;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Browser


(defparameter *locking-timeout* 10)

(capi:define-interface browser ()
  ((dbview            :accessor dbview            :initarg  :dbview)
   (header-height     :accessor header-height     :initarg  :header-height)
   (row-height        :accessor row-height        :initarg  :row-height)
;   (visible-row-count :accessor visible-row-count :initform 0)
   (query             :accessor query             :initarg  :query)
   (id-temp-table     :accessor id-temp-table     :initform "")
   (source-row-count  :accessor source-row-count  :initform 0)
   (spread            :accessor spread            :initarg  :spread)
   (max-pages         :accessor max-pages         :initarg  :max-pages)
   (page-size         :accessor page-size         :initarg  :page-size)
   (pages             :accessor pages             :initform '())
   (pos               :accessor pos               :initform 0)
   (selection         :accessor selection         :initform '())
   (lock              :accessor lock              :initform (mp:make-lock))
   )

  (:panes
   ;; ...filtering...

   (upper-button
    capi:push-button
    :accessor upper-button
    :text "Lekérdezés váltása"
    :callback-type :interface
    :callback (:initarg :upper-button))

   (selected
    capi:push-button
    :accessor selected
    :text "Kiválasztott elemek"
    :callback-type :interface
    :callback (:initarg :selected-button))

   (disp
    capi:title-pane
    :accessor disp
    :text "...")

   (mclp
    capi:multi-column-list-panel
    :accessor             mclp
    :columns              (:initarg :columns)
    :items                (:initarg :mclp-data)
    :interaction          :extended-selection
    :items-get-function   #'svref
    :item-print-functions #'(lambda (item)
                              (cond ((numberp item) (format nil "~a" item))
                                    ((member item '("NULL" nil) :test #'equal)
                                     "")
                                    (t item)))
    :horizontal-scroll    t
    :vertical-scroll      (:initarg :vertical-scroll-allowed)
    :selection-callback   (:initarg :selection-callback)
    :extend-callback      (:initarg :extend-callback)
    :retract-callback     (:initarg :retract-callback)
    :callback-type        :interface
;    :test-function        #'(lambda (item1 item2)
;                              (eq (elt item1 0) (elt item2 0)))
    :keep-selection-p     t
    )


   ;; ...import/export/exit...

   (lower-button
    capi:push-button
    :accessor lower-button
    :text "Kill-lépés"
    :callback-type :interface
    :callback (:initarg :lower-button)))

   (:layouts
    (upper capi:row-layout '(upper-button selected disp))
    (lower capi:row-layout '(lower-button))
;    (borders capi:column-layout '(upper lower))
    (default capi:column-layout '(upper mclp lower)))

   (:default-initargs
    :display-state :normal
    :window-styles '(:resizable)
    :layout 'default
    :visible-min-width '(/ :screen-width 2)
    :visible-max-width :screen-width
    :visible-min-height '(/ :screen-height 2)
    :visible-max-height :screen-height
    :page-size 100 ;50000

    :vertical-scroll-allowed t
    :mclp-data #()

    :upper-button nil
    :lower-button nil
    :query '()

    :selection-callback nil
    :extend-callback nil
    :retract-callback nil
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
                          :columns '((:title "."))
                          :mclp-data (coerce (loop for i from 0 below number-of-rows
                                                   collecting '(".."))
                                             'vector)
                          :vertical-scroll-allowed nil
                          )))
    (let* ((hgt1 (height (make-interface 1)))
           (hgt  (- (height (make-interface 2)) hgt1))
           (hhgt (- hgt1 hgt)))
      (values hgt hhgt))))


;;; Paging --------------------------------


(defmacro with-browser-locked ((obj) &body body)
  `(mp:with-lock ((lock ,obj) :timeout *locking-timeout*)
     ,@body))


(defmethod drop-temp-table ((obj browser))
  (with-browser-locked (obj)
    (with-slots (id-temp-table) obj
      (unless (string= id-temp-table "")
        (drop-table id-temp-table)
        (setf id-temp-table "")))))


(defmethod init-query-tempid ((obj browser))
  "Refresh ID temp table."
  (with-db-context
    (with-slots (id-temp-table) obj
      ;; Delete any existing temporary id table.
      (drop-temp-table obj)
      ;; Create new temporary table.
      (setf id-temp-table (unique-table-name (user-token)))
      (apply #'select-simple-id-into-temp
             (list (view-id (dbview obj)))
             (append (query obj)
                     (list :temp id-temp-table))))))


(defmethod init-row-count ((obj browser))
  "Find the number of rows in query, set it to both slot and vscroll bar range.
   Also set relative pos to 0."
  (with-db-context
    (let ((count (first
                  (elt (funcall *sqlfn* (format nil "select count(~a) from ~a"
                                                (view-id (dbview obj))
                                                (id-temp-table obj)))
                       0))))
      (setf (source-row-count obj) count))))


(defparameter *paging-mailbox* nil)

(defun start-paging-listener ()
  (mp:process-run-function
   "Paging listener"
   ()
   #'(lambda ()
       (setf *paging-mailbox* (mp:make-mailbox :size 10 :name "Paging listener mailbox"))
       (let ((event nil))
         (loop
          (setf event (mp:mailbox-wait-for-event *paging-mailbox* :wait-reason "Waiting for page fault."))
          (when (functionp event)
;            (wg-msg "~a" (mp:mailbox-count *paging-mailbox*))
            (funcall event))
          (setf event nil))))))


(defun simplify-worker (previous current rest)
  (if (null rest)
    ;; Nothing in rest, end processing
    (append previous (list current))
    ;; Compare current with first of rest
    (if (= (- (car (first rest)) (cdr current)) 1)
      (simplify-worker previous (cons (car current) (cdr (first rest)))
                       (rest rest))
      (simplify-worker (append previous (list current))
                       (first rest)
                       (rest rest)))))

(defun simplify-pages (pages)
  (let ((ordered (sort pages #'< :key #'car)))
    (simplify-worker nil (first ordered) (rest ordered))))
    
(defun load-page (obj from &optional (upto 0 upto-provided-p))
  (with-slots (dbview query id-temp-table page-size) obj
    (with-db-context
      (apply #'select-simple-by-temp
             (append (list (view-columns dbview))
                     query
                     (list :temp id-temp-table
                           :id   (view-id dbview)
                           :limit (if upto-provided-p (1+ (- upto from)) page-size)
                           :offset from
                           :order-by (view-order dbview)))))))

(defun reloader (obj missing-pages)
  (with-browser-locked (obj)
    (lambda ()
      (dolist (pair (simplify-pages missing-pages))
        ;; For every missing page, load the page...
        (let ((new (load-page obj (car pair) (cdr pair))))
          ;; Then copy it into the spread
          (loop for d from (car pair) upto (cdr pair)
                for s from 0 doing
                (setf (aref (spread obj) d)
                      (aref new s)))))
      ;; Set the spread as the data source of the list and reset position
      (capi:apply-in-pane-process
       obj
       #'(lambda ()
;         (wg-msg "~a" (simplify-pages missing-pages))
;         (save-selection obj)
           (setf (capi:collection-items (mclp obj)) (spread obj))
;         (restore-selection obj)
           (capi:scroll (mclp obj) :vertical :move (pos obj))
           )))))


(defmethod current-page ((obj browser))
  (floor (pos obj) (page-size obj)))


(defmethod in-mid-page-p ((obj browser))
  (with-slots (page-size pos) obj
    (let* ((current (current-page obj))
           (start   (* current page-size)))
      (<= start pos (1- (+ start page-size))))))


(defmethod relevant-pages ((obj browser))
  (with-slots (pos page-size max-pages source-row-count) obj
    (let* ((1dir    (floor max-pages 2))
           (current (current-page obj))
           (first   (max (- current 1dir) 0))
           (last    (min (+ current 1dir)
                         (floor source-row-count page-size))))
;      (wg-msg "Current: ~a~%First: ~a~%Last: ~a" current first last)
      (loop for i from first upto last
            for f = (* i page-size)
            for l = (min (1- (+ f page-size))
                         (1- source-row-count))
            collecting (cons f l)))))


;(defparameter *pages-loading* nil) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod refresh-pages ((obj browser))
  (with-browser-locked (obj)
    (with-slots (pos page-size max-pages source-row-count pages) obj
      (let ((relevant (relevant-pages obj)))
        (when (set-exclusive-or pages relevant :test #'equal)
          ;; Pages that must be flushed
          (let ((to-drop (set-difference pages relevant :test #'equal))
                ;; Pages that must be loaded
                (to-load (set-difference relevant pages :test #'equal)))
            ;; Emptying irrelevant pages
            (when (<= (+ (length pages) (length to-load)) max-pages)
              (dolist (drop to-drop)
                (loop for i from (car drop) upto (cdr drop) doing
                      (setf (aref (spread obj) i) nil))))
            ;; Refreshing PAGES in OBJ
            (setf (pages obj) relevant)
            ;; Query data for missing pages
            (when to-load
;            (wg-msg "Loading: ~a" to-load)
              (loop for retry from 0 below 100  ;  make conditions to allow longer wait
                    until *paging-mailbox*
                    doing (sleep 0.01))
              (mp:mailbox-send *paging-mailbox* (reloader obj to-load)))))))))


(defun start-vscroll-listener (obj)
  (mp:process-run-function
   "Vertical scroll listener" ()
   #'(lambda ()
       (loop for pos = (capi:get-scroll-position (mclp obj) :vertical) doing
#|             (unless (eq pos (pos obj))
               (setf (pos obj) pos
                     (capi:title-pane-text (disp obj))
                     (format nil "~a" pos)))
             (when (and pos
                        (set-exclusive-or (pages obj) (relevant-pages obj)))
               (refresh-pages obj))|#
             (unless (eq pos (pos obj))
               (with-browser-locked (obj)
                 (setf (pos obj) pos
                       (capi:title-pane-text (disp obj)) (format nil "~a" pos)))
               (when (numberp pos)
;                 (let* ((a (pages obj))
;                        (b (relevant-pages obj))
;                        (changed (set-exclusive-or (pages obj) (relevant-pages obj))))
;                   (wg-msg "~a~%~a" a b)
                   (when (set-exclusive-or (pages obj) (relevant-pages obj))
                     (refresh-pages obj))
;                   )
                 ))
             (sleep 0.3)))))


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

(defmethod save-selection ((obj browser))
  (with-browser-locked (obj)
    (setf (selection obj) (capi:choice-selection (mclp obj)))))

(defmethod restore-selection ((obj browser))
  (capi:apply-in-pane-process
   (mclp obj)
   #'(lambda ()
       (with-browser-locked (obj)
         (setf (capi:choice-selection (mclp obj))
               (selection obj))))))



(defun init-query (interface)
  (with-browser-locked (interface)
    (setf (pos interface) 0
          (pages interface) '()
          (selection interface) '())
    (restore-selection interface)
    ;; Init db stuff and the spread
    (init-query-tempid interface)
    (init-row-count interface)
    (setf (spread interface)
          (make-array (source-row-count interface)
                      :element-type 'list :initial-element nil))
    ;; Load initial pages to spread
    (refresh-pages interface)
    ;; Selection callbacks
    ))

(defun kill (&rest args) (declare (ignore args)))

(defun init-vscroll (interface paging-listener)
  ;; Starting listeners
  (let* ((vscroll-listener (start-vscroll-listener interface))
         (killer           #'(lambda (&rest args)
                               (declare (ignore args))
                               (with-browser-locked (interface)
                                 (mp:process-terminate vscroll-listener)
                                 (mp:process-terminate paging-listener)
                                 (setf *paging-mailbox* nil)
                                 (with-db-context 
                                   (drop-temp-table interface))
                                 (capi:destroy interface)))))
    ;; Set lower button to kill listeners
    (setf (capi:button-press-callback (lower-button interface)) killer
          (symbol-function 'kill) killer)))

(defun make-browser (view)
  "Create & initialize browser window."
  (multiple-value-bind (row-height header-height)
      (calculate-row-height)
    (let ((interface
           (make-instance
            'browser
            :columns         (mapcar #'(lambda (label)
                                         (list :title label))
                                     (view-labels view))
            :dbview          view
            :row-height      row-height
            :header-height   header-height
            :max-pages       5
            :upper-button    #'(lambda (interface)
                                 (setf (query interface)
                                       (next-query))
                                 (init-query interface))
            :selected-button #'(lambda (interface)
                                 (wg-msg "~a" (selection interface)))
            
            :selection-callback #'save-selection
            :extend-callback    #'save-selection
            :retract-callback   #'save-selection
            ))
          (paging-listener  (start-paging-listener))
          )
      (init-query interface)
      (init-vscroll interface paging-listener)
      interface)))



;;; ----------------------------------------------------------------------
;;; Sandbox


(defun test06 ()
  "Browser"
  (let ((browser (make-browser :main)))
    (capi:display browser)

#|    (sleep 10)
    (setf (selection browser) '(2 4 6 8 10))
    (restore-selection browser)|#
    
    ))


(defun test07 ()
  "Count selection"
  (with-db-context
    (count-simple (view-columns :main))))
