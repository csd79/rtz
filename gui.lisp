;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)



;;; ----------------------------------------------------------------------
;;; Main GUI


(capi:define-interface main ()
  ()
  (:panes
   (main-list
    capi:multi-column-list-panel
    :accessor main-list
    )
   (close-button
    capi:push-button
    :accessor close-button
    :text "Bezárás"
    :callback-type :interface
    :callback (:initarg #'(lambda (interface) (capi:destroy interface)))))
  )
