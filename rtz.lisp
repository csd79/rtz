;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:rtz)



;;; ----------------------------------------------------------------------
;;; Misc...


(defun user-token ()
  "user")


;;; ----------------------------------------------------------------------
;;; Main


(defun start ()
  (let ((state   (make-instance 'wax-script))
        (browser (make-browser :main)))
    (init-state state :last-user-id nil :db-file "")
    (load-state state :package-name "RTZ")
    (capi:display browser)))
