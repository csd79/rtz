;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*-


(in-package #:sig)


(defmacro with-db-context (&body body)
  `(unwind-protect
       (progn
         (unless (typep *db* 'sqlite-handle)
           (setf *db* (connect %dbfile% :busy-timeout *timeout*)))
         ,@body)
     (when (and *auto-close*
                (typep *db* 'sqlite-handle))
       (disconnect *db*)
       (setf *db* nil))))


(defun db-cleanup ()
  (when (typep *db* 'sqlite-handle)
    (disconnect *db*)))
