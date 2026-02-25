;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; Browser


(capi:define-interface browser ()
  ((dbview            :accessor dbview            :initarg  :dbview)
   (header-height     :accessor header-height     :initarg  :header-height)
   (row-height        :accessor row-height        :initarg  :row-height)
   (query             :accessor query             :initarg  :query)
   (id-temp-table     :accessor id-temp-table     :initform "")
   (source-row-count  :accessor source-row-count  :initform 0)
   (spread            :accessor spread            :initarg  :spread)
   (max-pages         :accessor max-pages         :initarg  :max-pages)
   (page-size         :accessor page-size         :initarg  :page-size)
   (pages             :accessor pages             :initform '())
   (pos               :accessor pos               :initform 0)
   (selection         :accessor selection         :initform '())
   (popup-selection   :accessor popup-selection   :initform '())
   (popup-values      :accessor popup-values      :initform '())
   (lock              :accessor lock              :initform (mp:make-lock))
   (paging-listener   :accessor paging-listener   :initform nil)
   (paging-mailbox    :accessor paging-mailbox    :initform nil)
   (vscroll-listener  :accessor vscroll-listener  :initform nil)
   )

  (:panes
   ;; ...filtering...

   (new-record
    capi:push-button
    :accessor new-record
    :text "Új rekord bevitele"
    :callback-type :interface
    :callback (:initarg :new-record))

   (update
    capi:push-button
    :accessor updateb
    :text "Módosítás"
    :callback-type :interface
    :callback (:initarg :updateb))

   (import-em
    capi:push-button
    :accessor import-em
    :text "Importálás"
    :callback-type :interface
    :callback (:initarg :import-em))

   (export-em
    capi:push-button
    :accessor export-em
    :text "Exportálás"
    :callback-type :interface
    :callback (:initarg :export-em))

   (invalidate
    capi:push-button
    :accessor invalidate
    :text "Storno"
    :callback-type :interface
    :callback (:initarg :invalidate))

   (bsettings
    capi:push-button
    :accessor bsettings
    :text "Beállítások"
    :callback-type :interface
    :callback (:initarg :bsettings))

   (reset-query
    capi:push-button
    :accessor reset-queryb
    :text "Rendezés/szûrés alaphelyzetbe"
    :callback-type :interface
    :callback (:initarg :reset-queryb))

   (selected
    capi:push-button
    :accessor selected
    :text "Kiválasztott elemek"
    :callback-type :interface
    :callback (:initarg :selected-button))

   (temp-disp
    capi:title-pane
    :accessor temp-disp
    :text "...")

   (mclp
    capi:multi-column-list-panel
    :accessor             mclp
    :columns              (:initarg :columns)
    :header-args          (:initarg :header-args)
    :auto-reset-column-widths nil
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
    :keep-selection-p     t

;    :background          :red ; IT'S WOIKINNN!!!!!!!
;    :color-function       #'(lambda (panel item state)
;                              (wg-msg "~a~%~a~%~a" panel item state))
    )
   )

   (:layouts
    (upper1 capi:row-layout '(new-record update import-em export-em invalidate bsettings))
    (upper2 capi:row-layout '(reset-query selected temp-disp))
    (default capi:column-layout '(upper1 upper2 mclp)))

   (:default-initargs
    :display-state :normal
    :window-styles '(:resizable)
    :layout 'default
    :visible-min-width '(/ :screen-width 2)
    :visible-max-width :screen-width
    :visible-min-height '(/ :screen-height 2)
    :visible-max-height :screen-height
    :page-size *page-size*

    :vertical-scroll-allowed t
    :mclp-data #()

    :query '()

    :selection-callback nil
    :extend-callback nil
    :retract-callback nil

    :new-record nil
    :updateb nil
    :invalidate nil
    :import-em nil
    :export-em nil
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
  "Locking context for any BROWSER object."
  `(mp:with-lock ((lock ,obj) :timeout *locking-timeout*)
     ,@body))


(defmethod drop-temp-table ((obj browser))
  "Drop temporary table (whose name is in OBJ)."
  (with-browser-locked (obj)
    (with-slots (id-temp-table) obj
      (unless (string= id-temp-table "")
;        (ignore-errors
          (drop-table id-temp-table)
;          )
        (setf id-temp-table "")))))


(defmethod init-query-tempid ((obj browser))
  "Refresh ID temp table."
  (with-db-context
    (with-slots (id-temp-table) obj
      ;; Delete any existing temporary id table.
      (drop-temp-table obj)
      ;; Create new temporary table.
      (setf id-temp-table (unique-table-name (user-token)))
      (apply #'select-id->temp
             (list (view-id (dbview obj)))
             (append (query obj)
                     (list :temp id-temp-table))))))


(defmethod init-row-count ((obj browser))
  "Find the number of rows in query, set it to both slot and vscroll bar range.
   Also set relative pos to 0."
  (with-db-context
    (let* ((statement (format nil "select count(~a) from ~a"
                              (view-id (dbview obj)) (id-temp-table obj)))
           (count (first (elt (funcall *sqlfn* statement) 0))))
      (setf (source-row-count obj) count))))


(defmethod start-paging-listener ((obj browser))
  "Start paging listener in a separate thread."
  (setf (paging-listener obj)
        (mp:process-run-function
         "Paging listener" ()
         #'(lambda ()
             (setf (paging-mailbox obj)
                   (mp:make-mailbox :size 10 :name "Paging listener mailbox"))
             (let ((event nil))
               (loop
                (setf event (mp:mailbox-wait-for-event
                             (paging-mailbox obj)
                             :wait-reason "Waiting for page fault."))
                (when (functionp event)
                  (funcall event))
                (setf event nil)))))))


(defun simplify-pages (pages)
  "Merge descriptor cells of neighboring pages."
  (labels ((worker (previous current rest)
             (if (null rest)
               ;; Nothing in rest, end processing
               (append previous (list current))
               ;; Compare current with first of rest
               (if (= (- (car (first rest)) (cdr current)) 1)
                 (worker previous (cons (car current) (cdr (first rest)))
                         (rest rest))
                 (worker (append previous (list current))
                         (first rest)
                         (rest rest))))))
    (let ((ordered (sort pages #'< :key #'car)))
      (worker nil (first ordered) (rest ordered)))))


(defun load-page (obj from &optional (upto 0 upto-provided-p))
  "Load a single page."
  (with-slots (dbview query id-temp-table page-size) obj
    (let ((*sqlfn* #'sql->sv))
      (apply #'select-by-temp
             (append (list (view-columns dbview))
                     query
                     (list :temp id-temp-table
                           :id   (view-id dbview)
                           :limit (if upto-provided-p (1+ (- upto from)) page-size)
                           :offset from
                           :order-by (view-order dbview)))))))


(defun reloader (obj missing-pages)
  "Worker fn for the paging listener: it loads MISSING-PAGES and refreshes the gui."
  (lambda ()
    (with-browser-locked (obj)
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
           (setf (capi:collection-items (mclp obj)) (spread obj))
           (capi:scroll (mclp obj) :vertical :move (pos obj)))))))


(defmethod current-page ((obj browser))
  "Number of the page pos resides in."
  (floor (pos obj) (page-size obj)))


(defmethod relevant-pages ((obj browser))
  "List the description cells for the ideal loaded pages for pos."
  (with-slots (pos page-size max-pages source-row-count) obj
    (let* ((1dir    (floor max-pages 2))
           (current (current-page obj))
           (first   (max (- current 1dir) 0))
           (last    (min (+ current 1dir)
                         (floor source-row-count page-size))))
      (loop for i from first upto last
            for f = (* i page-size)
            for l = (min (1- (+ f page-size))
                         (1- source-row-count))
            collecting (cons f l)))))


(defmethod refresh-pages ((obj browser))
  "Calculate ideal pageset, empty irrelevant pages and
   send fn to load the missing pages to the paging listener."
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
            ;; Send loader fn to the paging listener
            (when to-load
              (loop for retry from 0 below 100 ; make conditions to
                                               ; allow longer wait
                    until (paging-mailbox obj)
                    doing (sleep 0.01))
              (mp:mailbox-send (paging-mailbox obj) (reloader obj to-load)))))))))


(defmethod start-vscroll-listener ((obj browser))
  "Read vertical scrollbar position in a loop;
   call REFRESH-PAGES when the slug wanders off the current page."
  (setf (vscroll-listener obj)
        (mp:process-run-function
         "Vertical scroll listener" ()
         #'(lambda ()
             (loop for pos = (capi:get-scroll-position
                              (mclp obj) :vertical) doing
                   (unless (eq pos (pos obj))
                     (with-browser-locked (obj)
                       (setf (pos obj) pos
                             (capi:title-pane-text (temp-disp obj))
                             (format nil "~a" pos)))
                     (when (numberp pos)
                       (when (set-exclusive-or (pages obj) (relevant-pages obj))
                         (refresh-pages obj))))
                   (sleep *vscroll-listener-sleep*))))))


;;; Browser lifecycle ---------------------


(defmethod save-selection ((obj browser))
  "Save the list of currently selected elements into OBJ."
  (with-browser-locked (obj)
    (setf (selection obj) (capi:choice-selection (mclp obj)))))


(defmethod restore-selection ((obj browser))
  "Select items that stored in OBJ."
  (capi:apply-in-pane-process
   (mclp obj)
   #'(lambda ()
       (with-browser-locked (obj)
         (setf (capi:choice-selection (mclp obj))
               (selection obj))))))


(defmethod selected-records ((obj browser))
  "Return a list containing the selected records as lists."
  (selection obj))

  (mapcar #'(lambda (index)
              (aref (spread obj) index))
          (selection obj)))


(defun init-query (interface)
  "Init browser to show the current query."
  (with-browser-locked (interface)
    ;; Init pos, pages & selection
    (setf (pos interface) 0
          (pages interface) '()
          (selection interface) '())
    (restore-selection interface)
    ;; Init db stuff and the spread
    (init-query-tempid interface)
    (init-row-count interface)
    (setf (spread interface)
          (make-array
           (source-row-count interface)
           :element-type 'list :initial-element nil))
    ;; Load initial pages to spread
    (refresh-pages interface)))


(defmethod init-killswitch ((obj browser))
  "Upon closing window, kill listeners & delete temp tables."
  (setf (capi:interface-destroy-callback obj)
        #'(lambda (&rest args)
            (declare (ignore args))
            (with-browser-locked (obj)
              (mp:process-terminate (vscroll-listener obj))
              (mp:process-terminate (paging-listener obj))
              (setf (paging-mailbox obj) nil)
              (with-db-context 
                (drop-temp-table obj))
              (capi:destroy obj)))))


;;; Selection popup -----------------------


(defparameter *header-popup-items*
  '(;; Sorting
    (("Rendezés nélkül")
     ("Rendezés növekvõ sorrendbe"  ()                           :order-by (asc)         nil         ())
     ("Rendezés csökkenõ sorrendbe" ()                           :order-by (desc)        nil         ()))
    ;; Filtering
    (("Szûrés nélkül")
     ("Tartalmazza ..."             ("Tartalmazza")              :where    (like)        "%~a%"      (:date :string))
     ("Nem tartalmazza ..."         ("Nem tartalmazza")          :where    (not like)    "%~a%"      (:date :string))
     ("Kisebb ..."                  ("Kisebb mint")              :where    (<)           "~a"        (:date :integer))
     ("Nagyobb ..."                 ("Nagyobb mint")             :where    (>)           "~a"        (:date :integer))
     ("Kisebb vagy egyenlõ ..."     ("Kisebb vagy egyenlõ")      :where    (<=)          "~a"        (:date :integer))
     ("Nagyobb vagy egyenlõ ..."    ("Nagyobb vagy egyenlõ")     :where    (>=)          "~a"        (:date :integer))
     ("Értékhatárok között ..."     ("Alsó határ" "Felsõ határ") :where    (between)     "~a and ~a" (:date :integer))
     ("Értékhatárokon kívül ..."    ("Alsó határ" "Felsõ határ") :where    (not between) "~a and ~a" (:date :integer))
#|     ("Kiválasztott" 0)
     ("Nem kiválasztott" 0)|#
     )))

(defparameter *header-popup-items-exlusivity*
  '(t nil))


;;; Popup elements & items ----------------


(defun hpi-label-value (element-n label)
  "Number of popup item LABEL in ELEMENT."
  (let* ((element  (nth element-n *header-popup-items*))
         (position (position label element :key #'first :test #'string=)))
    (cond ((eq label :default) 0)
          (position            position)
          (t                   0))))


(defun hpi-value-label (element value)
  "Label of popup item numbered VALUE in ELEMENT."
  (first (nth value (nth element *header-popup-items*))))


(defun hpi-label-subs (element label)
  "Data belonging to ELEMENT/LABEL in the header popup menu."
  (let ((pos (position label (nth element *header-popup-items*) :key #'first :test #'string=)))
    (rest (nth pos (nth element *header-popup-items*)))))


(defun element (label)
  "Return position of popup menu element containing LABEL."
  (position-if #'(lambda (sublist)
                   (position label sublist :key #'first :test #'string=))
               *header-popup-items*))


(defun exclusive-element-p (label)
  "Is LABEL selectable in one column only at any given time?"
  (nth (element label) *header-popup-items-exlusivity*))


;;; Init/get/set popup selection/values ----


(defmethod init-popup ((obj browser))
  "Initialize POPUP-SELECTION and POPUP-VALUES."
  (let* ((column-count    (length (view-columns (dbview obj))))
         (length          (length *header-popup-items*))
         (popup-selection (loop for i from 0 below column-count collecting
                                (loop for j from 0 below length collecting 0)))
         (popup-values    (loop for i from 0 below column-count collecting '())))
    (setf (popup-selection obj) popup-selection
          (popup-values obj) popup-values)))


(defmethod get-popup-selection ((obj browser) column element)
  "Selected popup item in COLUMN / ELEMENT according to OBJ."
  (hpi-value-label
   element
   (nth element (nth column (popup-selection obj)))))


(defmethod set-popup-selection ((obj browser) column element label)
  "Save number of LABEL in OBJ as selected in COLUMN/ELEMENT."
  (setf (nth element (nth column (popup-selection obj)))
        (hpi-label-value element label)))


(defmethod get-popup-params ((obj browser) column)
  "Get parameters stored for COLUMN in OBJ."
  (nth column (popup-values obj)))


(defmethod set-popup-params ((obj browser) column values)
  "Set parameters for COLUMN in OBJ."
  (setf (nth column (popup-values obj)) values))


;;; Every popup selection for a column ----


(defmethod applicable-popup-items ((obj browser) column)
  "Filter popup items for COLUMN based on column type."
  (let* ((column* (nth column (view-columns (dbview obj))))
         (table   (first (table column*
                                :primary-key-allowed t
                                :foreign-allowed t)))
         (type    (column-type column* table)))
    (mapcar #'(lambda (element)
                (remove-if-not #'(lambda (item)
                                   (let ((sixth (sixth item)))
                                     (or (not sixth)
                                         (and sixth
                                              (member type sixth)))))
                               element))
            *header-popup-items*)))


(defmethod restore-popup-selection ((obj browser) elements column)
  "Set selected items for all elements in popup menu based on OBJ state."
  (loop for i from 0
        for element in elements doing
        (setf (capi:choice-selection element)
              (hpi-label-value i (get-popup-selection obj column i)))))


(defmethod save-popup-selection ((obj browser) column label)
  "Set LABEL as selected item for COLUMN in OBJ.
   Also set other columns unselected if LABEL is exclusive to a single column."
  (let* ((element     (element label))
         (exclusive-p (exclusive-element-p label))
         (previous    (get-popup-selection obj column element)))
    ;; Save new selection
    (set-popup-selection obj column element label)
    ;; When selection changed:
    (when (string/= label previous)
      ;; Also, when element is exclusive, set element in other columns to default
      (when exclusive-p
        (loop for i from 0 below (length (popup-selection obj)) doing
              (when (/= i column)
                (set-popup-selection obj i element :default)))))))


(defun popup-dialog (obj labels)
  "Ask for as many parameters as list LABELS suggest."
  (let ((panes (mapcar #'(lambda (label)
                           (make-instance 'capi:text-input-pane
                                          :callback-type :data :title label))
                       labels))
        (screen (capi:element-screen (mclp obj))))
    (multiple-value-bind (x y)
        (capi:current-pointer-position :relative-to screen)
      (capi:popup-confirmer
       (capi:make-container panes)
       "Érték(ek) megadása"
       :value-function #'(lambda (arg)
                           (declare (ignore arg))
                           (mapcar #'capi:text-input-pane-text panes))
       :x x :y y :position-relative-to screen
       :window-styles '(:always-on-top :borderless :movable-by-window-background)))))


(defmethod save-popup-params ((obj browser) column label)
  "When item LABEL in the popup menu requires parameters, ask for them
   using a dialog, then save them in OBJ."
  (let* ((element (element label))
         (subs    (hpi-label-subs element label))
         (params  (first subs))
         (vals    (when params
                    (popup-dialog obj params))))
    (when (notany #'(lambda (e)
                      (and (stringp e) (string= e "")))
                  vals)
      (set-popup-params obj column vals))
    (or vals
        (not params))))


;;; Refresh query -------------------------
    

(defmethod resolve-single-clauses ((obj browser) column subs values)
  "Construct sorting/filtering clause for a single column."
  (destructuring-bind (labels keyword ops format types)
      subs
    (declare (ignore labels types))
    (append (list keyword (nth column (view-columns (dbview obj))))
            ops
            (when (and format values)
              (list (apply #'format nil format values))))))


(defun reduce-clauses (heap)
  "Construct sorting/filtering clause for the query."
  (let* ((keywords (remove-duplicates (mapcar #'first heap))))
    (mapcar #'(lambda (keyword)
                (let ((relevants (remove-if-not
                                  #'(lambda (row)
                                      (eq (first row) keyword))
                                  heap)))
                  (list keyword
                        (butlast (apply #'append (mapcar #'(lambda (subexpr)
                                                             (list (rest subexpr) 'and))
                                                         relevants))))))
            keywords)))

(defmethod trigger-new-query ((obj browser))
  "Build new sorting/filtering query clauses based in popup selection stored in OBJ, then call INIT-QUERY."
  (let ((heap   '())
        (result nil))
    (loop for column from 0
          for selection in (popup-selection obj)
          for values in (popup-values obj) doing
          (loop for element from 0
                for num in selection
                for label = (hpi-value-label element num)
                for subs  = (hpi-label-subs element label) doing
                (when subs
                  (push (resolve-single-clauses obj column subs values)
                        heap))))
    (setf result (reduce-clauses (nreverse heap)))
    (setf (query obj) (apply #'append result))
    (init-query obj)))


;;; Header & popup menu -------------------


(defparameter *checked* (code-char 9745))
(defparameter *non-checked* (code-char 9744))

(defun checked-title (title &optional (check nil))
  "Add checkbox before title."
  (format nil "~a  ~a"
          (if check *checked* *non-checked*)
          title))

(defun uncheck-checked-title (checked-title)
  "Remove any checkmarks from title string (for comparison)."
  (let* ((words (str:words checked-title))
         (start (search (second words) checked-title)))
    (if (member (first words) (list *checked* *non-checked*) :test #'string=)
      (subseq checked-title start)
      checked-title)))

(defun columns-with-selected (obj)
  "List NIL for columns with default selection, T otherwise."
  (mapcar #'(lambda (sublist)
              (when (member-if-not #'zerop sublist) t))
          (popup-selection obj)))

(defun view-columnheads (view &optional (obj nil)); &optional (check nil))
  "Create column definition for the browser class."
  (let ((labels (view-labels view)))
    (mapcar #'(lambda (label colwidth check)
                (list :title (checked-title label check)
                      :width colwidth
                      :visible-min-width 20))
            labels
            (view-colwidths view)
            (if obj
              (columns-with-selected obj)
              (make-list (length labels) :initial-element nil)))))

(defun refresh-columnheads (obj)
  "Refresh column headers according to current sorting/filtering."
  (capi:modify-multi-column-list-panel-columns 
   (mclp obj)
   :columns (view-columnheads (dbview obj) obj))
  t)

(defun header-popup (interface column)
  "Create menu for the header of COLUMN with elements according to INTERFACE state."
  (let ((elements
         (mapcar #'(lambda (element)
                     (make-instance
                      'capi:menu-component
                      :items (mapcar #'first element)
                      :interaction :single-selection
                      :callback #'(lambda (data interface)
                                    (when (save-popup-params
                                           interface column data)
                                      (save-popup-selection interface column data)
                                      (refresh-columnheads interface)
                                      (trigger-new-query interface)))))
                 (applicable-popup-items interface column))))
    (restore-popup-selection interface elements column)
    (make-instance 'capi:menu :items elements)))


(defmethod reset-query ((obj browser))
  "Initialize sorting/filtering, then the whole browser."
  (setf (query obj) '())
  (init-popup obj)
  (init-query obj))


;;; Import, Export & Setting buttons ------


(defun import-from-xlsx (interface);;;;;;;;;;;;;;;;;; with-browser-locker ????
  "Ask for import files, then trigger import and RESET-QUERY."
  (let* ((raws  (capi:prompt-for-files "Üzenet" :filter "*.xlsx" ))
         (files (sort (mapcar #'namestring raws) #'string<=)))
    (when files
      (with-db-context
        (let ((obj (make-instance 'wax-script :execute-fn #'import-xlsxs)))
          (dolist (file files)
            (add-data-source obj (intern (symbol-name (gensym)) :keyword)
                             (namestring file)))
          (wax-execute obj :errorsink-on nil)))
      (reset-query interface))))


(defun export-to-xlsx (obj)
  "Save selection to an xlsx file."
  (let ((file (str:ensure-suffix
               ".xlsx"
               (namestring (capi:prompt-for-file
                            "Üzenet" :filter "*.xlsx"
                            :if-exists :ok :if-does-not-exist :ok))))
        (data (with-browser-locked (obj)
                (load-page obj 0)))
        (cnt  0))
    (with-wax-errorsink obj
      (with-property-accessors
        (setf (errorsink-on) nil
              (property-accessors-on) t)
        (with-workbook (:wbook wbook :wsvars (ws1) :save t)
          ;; Save new workbook by name FILE.
          (!saveas wbook file)
          ;; Write headers
          (let* ((labels (view-labels (dbview obj)))
                 (width  (length labels)))
            (setf (xrange ws1 1 1 width 1)
                  (coerce labels 'vector))
            ;; Write rows
            (loop for raw across data
                  for row = (mapcar #'(lambda (element)
                                        (if (equalp element "NULL")
                                          ""
                                          element))
                                    raw)
                  for r from 2 doing
                  (setf (xrange ws1 1 r width r)
                        (coerce row 'vector))
                  (incf cnt)))
          ;; Formatting
          (autofit-cols ws1)
          (freeze-panes ws1 :after-column 1 :after-row 1))))))


(defun settings ()
  ""
  (let ((obj (make-instance 'wax-script)))
    (init-state obj :last-user-id nil :db-file "")
    (load-state obj :package-name "RTZ")
    (wg-window
     "Beállítások"
     180
     "Adatbázisfájl" ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     (wg-file-selector
      "Adatbázisfájl"
      "*.db"
      '(".DB fájlok" "*.db" "Minden fájl" "*.*")
      #'(lambda (text &rest rest)
          (declare (ignore rest))
          (let ((string (str:replace-all "\\" "/" text)))
            (setf (get-state obj :db-file) string)))
      (str:replace-all "/" "\\" (namestring (get-state obj :db-file)))
      :cancel #'(lambda () (setf (get-state obj :db-file) nil)))
     (wg-button ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      "OK"
      #'(lambda (interface)
          (declare (ignore interface))
          (setf (get-state obj :db-file)
                (resolve-network-filename (get-state obj :db-file)))
          (wg-msg "~a" (get-state obj :db-file))
          (save-state obj :package-name "RTZ"))))))


;;; New / update --------------------------


(defun input-mode (modus length)
  (case modus
    (:new (cond ((zerop length) :new)
                ((= length 1)   :new-like-one)
                ((> length 1)   :new-like-many)))
    (:modify (cond ((zerop length) :nothing)
                   ((= length 1)   :modify-all)
                   ((> length 1)   :modify-impersonal)))
    (t nil)))


(defun input-window (obj &optional (mode :new))
  (let* ((selected (selected-records obj))
         (mode     (input-mode mode (length selected))))
    (wg-msg "~a  ~a" mode selected)))
;         (impersonals (view-impersonal (dbview obj)))
         

#|(defun input-window (&optional (rows '()))
  (declare (ignore rows))
  (let ((data  '(:a "Hihi" :b "Haha" :c "Hoho")))
    (flet ((field (data key &optional (callback nil))
             (wax::wg-text-input2
              callback 
              (getf data key)
              #'(lambda (&rest rest)
                  (declare (ignore rest))
                  "Új érték."))))
      (let ((fields (mapcar #'(lambda (key) (field data key)) '(:a :b :c))))
        (apply
         #'wg-window
         (append (list "Ablakocska" 80)
                 (apply #'append (mapcar #'list '("Elsõ" "Második" "Harmadik")
                                         fields))
                 (list (wg-button 
                        "OK"
                        #'(lambda (interface)
                            (declare (ignore interface))
                            (mapc #'(lambda (key pane)
                                      (setf (getf data key)
                                            (capi:text-input-pane-text pane)))
                                  '(:a :b :c)
                                  fields)
                            (wg-msg "~a" data)
                            ))
                       (wg-button
                        "Mégsem"
                        nil)
                       )
                 ))))))|#


;;; BROWSER -------------------------------


(defun header-callback (item interface)
  "Display HEADER-POPUP."
  (let* ((list (view-labels (dbview interface)))
        (column (position (uncheck-checked-title item)
                          list :test #'string=)))
    (multiple-value-bind (x y)
        (capi:current-pointer-position
         :relative-to (mclp interface))
      (capi:display-popup-menu
       (header-popup interface column)
       :owner (mclp interface)
       :button :button-1
       :x x :y y))))


(defun make-browser (view)
  "Create & initialize browser window."
  (multiple-value-bind (row-height header-height)
      (calculate-row-height)
    ;; STAGE 1
    (let ((interface
           (make-instance
            'browser
            :columns            (view-columnheads view)
            :header-args        `(:selection-callback ,#'header-callback
                                  :callback-type :item-interface)
            :dbview             view
            :row-height         row-height
            :header-height      header-height
            :max-pages          5
            :reset-queryb       #'reset-query
            :selected-button    #'(lambda (interface)
                                    (wg-msg "~a" (selected-records interface)))
            :selection-callback #'save-selection
            :extend-callback    #'save-selection
            :retract-callback   #'save-selection
            :export-em  #'export-to-xlsx
            :import-em  #'import-from-xlsx
            :bsettings  #'settings
            :new-record #'(lambda (interface) (input-window interface :new))
            :updateb    #'(lambda (interface) (input-window interface :modify)))))
      ;; STAGE 2
      (start-paging-listener interface)
      (reset-query interface)
      (sleep 2) ; Without this, setting the column widths would mess
                ; with the next step. perhaps every init step should
                ; be wrapped inside its own WITH-BROWSER-LOCKED
      ;; PHASE 3
      (with-browser-locked (interface)
        (start-vscroll-listener interface)
        (init-killswitch interface))
      interface)))


;;; ----------------------------------------------------------------------
;;; Sandbox


