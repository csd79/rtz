;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:cl-user)


(defpackage #:rtz
  (:use #:cl #:ccom3 #:achar #:transl #:msoffice #:sqlite #:wax #:iterate)
  (:export
   ;; GLOBALS.LISP
   #:%dbfile%                             ; DB file pathname, based on *DB-LOCATION* and *DB-NAME*
   #:*db*                                 ; DB handle
   #:*timeout*
   #:*auto-close*
   #:*rows-per-statement*                 ; number of rows to import in a single query
;   #:

   ;; SCHEMA.LISP
   #:*schema*
;   #:

   ;; UTILITIES.LISP
   #:string->symbol                       ; convert any string to symbol
   #:symbol->string                       ; convert any symbol to string
   #:synonym=                             ; compare 2 things using a synonyms dictionary
   #:string-similarity                    ; calculate word similarity based on Levenshtein distance
   #:*string-similarity-threshold*        ; STRING~ similarity threshold
   #:string~                              ; string similarity predicate
       ;; db context
   #:with-db-context                      ; establishes DB connection with *TIMEOUT*,
                                          ; closes upon exiting when *AUTO-CLOSE*
   #:db-cleanup                           ; should be called upon exiting app
       ;; schema handling
   #:schema-tables                        ; list names of tables
   #:schema-columns                       ; list columns of table
   #:column-description                   ; get SQL description of column in table
   #:column-import                        ; get name of import header for column in table
   #:many-joins                           ; list joins defined for many-table
   #:one-tables                           ; list one-tables
   #:many-tables                          ; list many-tables
   #:import-columns                       ; list all columns in table that has an import header attached
   #:foreign-columns                      ; list all columns in table that has no import header attached
   #:immediate-p                          ; does column in table have an :import key?
   #:foreign-p                            ; is column in table without an :import key?
   #:root-table                           ; name of the root table
   #:new-only-p                           ; T if table should cointain unique records
   #:primary-key-p                        ; T if column is table's primary key
   #:primary-key                          ; what column is the primary key of TABLE?
   #:view                                 ; return view
   #:view-id                              ; id column name for VIEW
   #:view-columns                         ; columns of VIEW
   #:view-labels                          ; labels column of VIEW
   #:view-order                           ; default ordering for VIEW
       ;; types
   #:sequencep                            ; 
   #:seq-of-strings-p                     ; 
   #:seq-of-strings                       ; 
   #:seq-of-seqs-p                        ; 
   #:seq-of-seqs                          ; 
   #:stringp-or-symbolp                   ; 
   #:seq-of-strings-or-symbols-p          ; 
   #:seq-of-strings-or-symbols            ; 
   #:seq-of-strings-symbols-or-bumbers-p  ; 
   #:seq-of-strings-symbols-or-numbers    ; 
   #:seq-of-seqs-of-strings-or-symbols-p  ; 
   #:seq-of-seqs-of-strings-or-symbols    ; 
       ;; statements
   #:sql-name                             ; convert symbol/string to string that can name an SQL element
   #:existing-tables                      ; list existing tables in DB
   #:*temp-name*                          ; 
   #:unique-table-name                    ; create unique table name in DB containing infix
   #:join-clauses                         ; list left join substatements for table
   #:column-names                         ; parse column names from: list, string, xarray, vector, array
   #:sql-list                             ; convert list of string, symbols or numbers to an SQL list
       ;; Excel support
   #:xlval->sql                           ; convert single xarray value to SQL value
;   #:

   ;; SQL.LISP
   #:verify-statements                    ; dump SQL statements (& results) formed by calls in body
   #:statement                            ; make SQL statement by interpolationg params into control string
   #:sql->list                            ; execute statement return results as list
   #:sql->sv                              ; execute statement return results as vector
   #:*sqlfn*                              ; function to call for sending SQL statements to db
   #:column-definition                    ; create column definition substatement based on *SCHEMA*
   #:all-column-definitions               ; create all column def substatements for table
   #:literal-column-defs                  ; reform literal column definitions as SQL list
   #:param-pattern                        ; create a pattern of SQL parameters
       ;; *DB* operations
   #:drop-table                           ; drop table from *DB*
   #:drop-all-tables                      ; drop all tables from *DB*
   #:table-info                           ; return a list of column descriptions for table
   #:table-columns                        ; list names of columns in table
   #:db-info                              ; print description of every table in *db*
   #:dump-table                           ; 
   #:number-of-rows                       ; 
   #:create-table                         ; create table from a list of column definitions
   #:insert                               ; insert a list of values into listed columns of a table
   #:select                               ; basic SELECT
       ;; smart-select
   #:table                                ; what table does column appear in?
   #:qualified-p                          ; does column contain table name prefix?
   #:unqualify                            ; remove table name from column name
   #:qualify                              ; add table name prefix to column name
   #:where-column-p                       ; is element at index a column name in where clause
   #:where-columns                        ; all column names in where clause
   #:qualify-where                        ; ensure qualified column names in where clause
   #:from-tables                          ; filter tables to the one that are not one-tables in schema
   #:join-keys                            ; list key columns that lead from table to column (if any)
   #:all-join-keys                        ; JOIN-KEYS for multiple routes
   #:find-join                            ; find the join that uses KEY
   #:frills                               ; calculate from tables, join clauses and proper where clause
   #:smart-select                         ; simplified SELECT
   #:count-simple                         ; COUNT, accepting the same args as SMART-SELECT
   #:select-id->temp                      ; create temp table, select id column into it
   #:select-by-temp                       ; select columns where row id is in TEMP
;   #:

   ;; IMPORT.LISP
   #:import-xarray                        ; go over rows of source in OBJ by groups, import them into TABLE
   #:temp->fix                            ; move data from TEMP into fix tables
   #:import-xlsx

   ;; GUI.LISP
   #:make-browser                         ; create a browser window
;   #:

   ;; SIG.LISP
   #:init-db                              ; create schema tables in db, fill in TKs
   #:user-token                           ; short name of the current user
   #:start                                ; ...soon...
;   #:

   ;; SANDBOX.LISP
   #:*ctest-iterations*
   #:with-ctest-db
   #:ctest-init
   #:ctest-start
   #:test01
;   #:

   ;; TEST.LISP
   #:row                                  ; random person's data in a list
   #:print-row                            ; print person's data in a form that can be turned into Excel columns
;   #:
   ))
