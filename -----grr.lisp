(defparameter *source*
  (coerce (loop for i from 0 below 1000 collecting
                (list (random 1000) (random 1000) (random 1000)))
          'simple-vector))
(defparameter *pages* (make-array (length *source*) :element-type 'list :initial-element nil))
(defparameter *page-size* 150)
(defparameter *page-start* 0)


(defun page (browse view-start)
  ;; Set *PAGE-START* to safe position
  (flet ((set-page (index value) (setf (aref *pages* index) value)))
    (setf *page-start* (max (- view-start (round *page-size* 2)) 0))
    (let* ((length (length *source*))
           (end    (min (+ *page-start* *page-size*) length)))
      ;; Set elements before page to NIL
      (loop for i from 0 below *page-start* doing (set-page i nil))
      ;; Set page elements
      (loop for i from *page-start* below end doing (set-page i (aref *source* i)))
      ;; Set elements after page to NIL
      (loop for i from end below length doing (set-page i nil)))
    (setf (capi:collection-items browse) *pages*)))


(defun xx ()
  (let* ((listener nil)
         (disp     (make-instance 'capi:title-pane :text "..."))
         (browse   (make-instance
                    'capi:multi-column-list-panel
                    :columns            '((:title "a")
                                          (:title "b")
                                          (:title "c"))
                    :items              (make-array (length *source*)
                                                    :element-type 'list
                                                    :initial-element nil)
                    :interaction        :extended-selection
                    :horizontal-scroll  t
                    :vertical-scroll    t
                    :items-get-function #'svref
                    ))
         (quit     (make-instance 'capi:push-button
                                  :text "Kill listener"
                                  :callback #'(lambda (&rest args)
                                                (declare (ignore args))
                                                (mp:process-terminate listener)))))
    ;; Initialize browser contents
    (page browse 0)
    ;; Start pager listener
    (setf listener (mp:process-run-function
                    "Pager listener" ()
                    #'(lambda ()
                        (loop for pos = (capi:get-scroll-position browse :vertical) doing
                              (setf (capi:title-pane-text disp)
                                    (format nil "~a" pos))
                              (when pos
                                (unless (<= *page-start*
                                            pos
                                            (- (+ *page-start* *page-size*) 20)) ; 20: VISIBLE-ROW-COUNT
                                  (capi:apply-in-pane-process
                                   browse
                                   #'(lambda ()
                                       (page browse pos)
                                       (capi:scroll browse :vertical :move pos)
                                       ))))
                              (sleep 0.3)))))
    ;; Display
    (capi:contain (make-instance 'capi:column-layout
                                 :description (list disp browse quit)))
    ))
