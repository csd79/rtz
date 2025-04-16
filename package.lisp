;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:cl-user)


(defpackage #:sig
  (:use #:cl #:ccom3 #:achar #:msoffice #:sqlite #:wax #:iterate)
  (:export
   #:with-db-context
   #:db-cleanup
   #:schema-tables
   #:schema-columns
   #:column-description
   #:many-joins
   #:sqlite-name
   #:existing-tables
   #:unique-table-name
   #:join-clauses
#|   #:
   #:
   #:
   #:
|#



   #:start
   ))



