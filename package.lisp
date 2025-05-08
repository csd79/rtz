;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:cl-user)


(defpackage #:sig
  (:use #:cl #:ccom3 #:achar #:msoffice #:sqlite #:wax #:iterate)
  (:export
   ;; globals.lisp
   #:%dbfile%
   #:*db*
   #:*timeout*
   #:*auto-close*
;   #:

   ;; schema.lisp
   #:*schema*
;   #:

   ;; utilities.lisp
   #:string->symbol
   #:symbol->string
   #:rmapcar
   #:with-db-context
   #:db-cleanup
   #:schema-tables
   #:schema-columns
   #:column-description
   #:many-joins
   #:sql-name
   #:existing-tables
   #:unique-table-name
   #:join-clauses
   #:column-names
   #:sequencep
   #:seq-of-strings-p
   #:seq-of-strings
   #:seq-of-seqs-p
   #:seq-of-seqs
   #:stringp-or-symbolp
   #:seq-of-strings-or-symbols-p
   #:seq-of-strings-or-symbols
   #:seq-of-seqs-of-strings-or-symbols-p
   #:seq-of-seqs-of-strings-or-symbols
   #:sql-list
   #:get-xarray
   #:xlval->sql
;   #:

   ;; sql.lisp
   #:statement
   #:sql->list
   #:column-definition
   #:all-column-definitions
   #:literal-column-defs
   #:param-pattern
   #:drop-table
   #:drop-all-tables
   #:table-info
   #:table-columns
   #:db-info
   #:dump-table
   #:number-of-rows
   #:create-table
   #:insert-into
;   #:insert-new-into
;   #:

   ;; import.lisp
   #:import-xlsx
;   #:

   ;; sig.lisp
   #:init-db
   #:start
;   #:

   ;; sandbox.lisp
   #:*ctest-iterations*
   #:with-ctest-db
   #:ctest-init
   #:ctest-start
   #:test01
;   #:
   ))



