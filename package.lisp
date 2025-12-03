;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:cl-user)


(defpackage #:rtz
  (:use #:cl #:ccom3 #:achar #:transl #:msoffice #:sqlite #:wax #:iterate)
  (:export

   ;; GLOBALS.LISP
   #:%dbfile%                      ; DB file pathname (by *DB-LOCATION*/*DB-NAME*)
   #:*db*                          ; DB handle
   #:*timeout*
   #:*auto-close*
   #:*rows-per-statement*          ; number of rows to import in a single query
       ;; Types
   #:seq-of-strings
   #:seq-of-seqs
   #:seq-of-strings-or-symbols
   #:seq-of-strings-symbols-or-numbers
   #:seq-of-seqs-of-strings-or-symbols
   #:value-list
   #:enclosed-value-list
       ;; TKs
   #:*tk-synonyms*



   ;; SCHEMA.LISP
   #:*schema*



   ;; UTILITIES.LISP
   #:string->symbol                ; convert any string to symbol
   #:symbol->string                ; convert any symbol to string
   #:rmapcar                       ; recursive mapcar for a single sequence
   #:string-similarity             ; based on Levenshtein distance
   #:*string-similarity-threshold* ; STRING~ similarity threshold
   #:string~                       ; string similarity predicate
   #:hudate->sql                   ; HUDATE -> "yyyy-mm-dd"
   #:clean-str-sql                 ; clean STRING, wrap it in 's
       ;; db context
   #:with-db-context               ; opens/closes DB
   #:db-cleanup                    ; should be called upon exiting app
       ;; statements
   #:sql-name                      ; symbol/string=>string that can name SQL stuff
   #:existing-tables               ; list existing tables in DB
   #:*temp-name*                   ; 
   #:unique-table-name             ; create unique table name containing infix
   #:join-clauses                  ; list left join substatements for table
   #:column-names                  ; list/string/xarray/vector/array=>col.names
   #:septd                         ; LIST elements separated by a space
   #:sql-list                      ; list of string/symbols/numbers=>SQL list
       ;; Network pathnames
   #:network-drives                ; list Windows network drive connections
   #:resolve-network-filename      ; network drive path=>true network path



   ;; SCHEMA-HANDLING.LISP
       ;; utilities
   #:select-table                  ; TABLE's sub-plist from SCHEMA
   #:select-column                 ; COLUMN's sub-plist from TABLE
   #:find-import-if                ; find import that satisfies PREDICATE
   #:default-import                ; name of default import
   #:import-mapping                ; return mapping for IMPORT
   #:map-import                    ; import headers->schema column names
   #:column-impersonal             ; is COLUMN mass-updateable?
   #:import-columns                ; list columns with import header attached
   #:schema-transl                 ; default transl selector label for schema
   #:table-transl                  ; default transl selector label for table
   #:foreign-columns               ; list columns with no import header attached
   #:new-only-p                    ; T if table should cointain unique records
       ;; SQL
   #:schema-tables                 ; list names of tables
   #:schema-columns                ; list columns of table
   #:column-description            ; get SQL description of column in table
   #:many-joins                    ; list joins defined for many-table
   #:all-connections
   #:one-tables                    ; list one-tables
   #:many-tables                   ; list many-tables
   #:immediate-p                   ; does column in table have an :import key?
   #:foreign-p                     ; is column in table without an :import key?
   #:primary-key-p                 ; T if column is table's primary key
   #:foreign-table                 ; foreign table linked to TABLE by COLUMN
   #:column-transl                 ; transl selector label for COLUMN
   #:table                         ; what table does COLUMN belong to?
       ;; import
   #:column-import                 ; get name of import header for column in table
   #:root-table                    ; name of the root table
   #:primary-key                   ; what column is the primary key of TABLE?
       ;; GUI
   #:view                          ; return view
   #:view-id                       ; id column name for VIEW
   #:view-columns                  ; columns of VIEW
   #:view-labels                   ; labels column of VIEW
   #:view-colwidths                ; column widths of VIEW
   #:view-order                    ; default ordering for VIEW
   #:column-type                   ; type of COLUMN in TABLE
   #:view-impersonal               ; list impersonal columns from VIEW



;; TRANSLATIONS.LISP
   #:*rtz-translations*
   #:*rtz-syns*



;; SQL.LISP
       ;; base layer
   #:verify-statements             ; dump SQL statements (& results)
   #:statement                     ; make SQL statement
   #:sql->list                     ; execute statement return results as list
   #:sql->sv                       ; execute statement return results as vector
   #:*sqlfn*                       ; function to call for dispatching statements
   #:column-def                    ; create column definition substatement
   #:column-defs                   ; create all column def substatements for table
   #:flat-column-defs              ; reform literal column definitions as SQL list
   #:param-pattern                 ; create a pattern of SQL parameters
   #:where=                        ; where clause where every COLUMN equals VALUE
   #:select-same                   ; select from TABLE where WHERE= is true
       ;; tables&DB info
   #:table-info                    ; list of column descriptions for table
   #:table-columns                 ; list names of columns in table
   #:dump-table                    ; TABLE contents->list
   #:number-of-rows                ; number of rows in TABLE
   #:db-info                       ; print description of every table in *db*
       ;; clauses for SELECT & UPDATE
   #:col                           ; 'TABLE.COLUMN' subclause
   #:clause                        ; general worker generating clauses
   #:clause-left-join              ; generate single left join clause
   #:clauses-left-join             ; generate multiple left join clauses
   #:clause-order-by               ; generate order by clause
       ;; operations
   #:init-db                       ; create schema tables in db, fill in TKs
   #:drop-table                    ; drop table from *DB*
   #:drop-all-tables               ; drop all tables from *DB*
   #:create-table                  ; create table from list of column definitions
   #:insert                        ; insert values into columns of a table
   #:select                        ; basic SELECT
   #:cols=vals                     ; COL1=VAL1, COL2=VAL2 subexpressions
   #:update                        ; replace values in rows identified by IDS
       ;; smart helpers
   #:qualified-p                   ; does column contain table name prefix?
   #:unqualify                     ; remove table name from column name
   #:qualify                       ; add table name prefix to column name
   #:where-column-p                ; is element a column name in a where clause?
   #:where-columns                 ; all column names in where clause
   #:update-src                    ; update source part of LABEL (if SRC/="")
   #:column-transl-label           ; transl label specific to COLUMN
   #:transl-vals                   ; transl elements of a value list at INDEX
   #:where-value-p                 ; is element at INDEX is a value for where?
   #:transl-where-value            ; column-specific transl of value at INDEX
   #:rewrite-where                 ; ensure qualified column names in where clause
   #:from-tables                   ; tables that are not one-tables in schema
   #:join-keys                     ; list key columns leding from table to column
   #:all-join-keys                 ; JOIN-KEYS for multiple routes
   #:find-join                     ; find the join that uses KEY
   #:smarty                        ; generate frills
       ;; auto-resolve ops
   #:resolve-column                ; COLUMN subtree for RESOLVE-TABLE
   #:resolve-table                 ; tree describing columns/values/connections
   #:smart-resolve                 ; insert values guided by RESOLVE-TABLE tree
   #:smart-context                 ; mid-layer between RESOLVE- & OP-FNs
       ;; smart operations
   #:smart-select                  ; select using unqualified columns namesXS
   #:select-id->temp               ; create temp table, select id column into it
   #:select-by-temp                ; select columns where row id is in TEMP
   #:smart-insert                  ; insert into tables when root values are new
   #:smart-update                  ; update with unqualified columns names



   ;; IMPORT.LISP
       ;; xarray->temp
   #:collect-row-values            ; collect values from ROWS into list
   #:group-rows                    ; xarray rows of a single group
   #:import-xarray                 ; import each rows of OBJ source into TABLE
       ;; temp->fix
   #:temp->fix                     ; move data from TEMP into fix tables
       ;; operations
   #:import-xlsx                   ; import .xlsx files into DB



   ;; GUI.LISP
       ;; browser
   #:browser                       ; main window class
   #:calculate-row-height          ; height of single data row & array header
       ;; paging
   #:with-browser-locked           ; locking context for BROWSER obj
   #:drop-temp-table               ; drop temporary table
   #:init-query-tempid             ; refresh table of IDs for current selection
   #:init-row-count                ; initialize source row count in OBJ
   #:start-paging-listener         ; start paging listener is separate thread
   #:simplify-pages                ; merge descriptor cells of neigbor pages
   #:load-page                     ; load single page
   #:reloader                      ; worker: load missing pages & refresh GUI
   #:current-page                  ; number of page of POS
   #:relevant-pages                ; descriptors of ideal page set
   #:refresh-pages                 ; empty irrelevant pages & load relevant ones
   #:start-vscroll-listener        ; call REFRESH-PAGES when slug goes of current
       ;; lifecycle
   #:save-selection                ; save currently selected elementsto OBJ
   #:restore-selection             ; select items stored in OBJ
   #:selected-records              ; contents of selected records
   #:init-query                    ; init browser to show current query
   #:init-killswitch               ; kill listeners & delete temp tables
       ;; selection popup
   #:*header-popup-items*
   #:*header-popup-items-exclusivity*
       ;; popup elements&items
   #:hpi-label-value               ; number of item LABEL in ELEMENT
   #:hpi-value-label               ; label of popup item
   #:hpi-label-subs                ; data belonging to ELEMENT/LABEL
   #:element                       ; poaition of element containing LABEL
   #:exclusive-element-p           ; is LABEL selectable in single col at a time?
       ;; init/get/set popup selections/values
   #:init-popup                    ; initialize POPUP-SELECTION & POPUP-VALUES
   #:get-popup-selection           ; COLUMN/ELEMENT selection in OBJ
   #:set-popup-selection           ; save selected LABEL to OBJ
   #:get-popup-params              ; get parameters stored for COLUMN in OBJ
   #:set-popup-params              ; set parameters for COLUMN in OBJ
       ;; every popup selection for a column
   #:applicable-popup-items        ; filter items based on COLUMN type
   #:restore-popup-selection       ; set selected items for all elements by OBJ
   #:save-popup-selection          ; save label as selected for COLUMN in OBJ
   #:popup-dialog                  ; ask for LABELS parameters
   #:save-popup-values             ; ask for&save required params for LABEL
       ;; refresh query
   #:resolve-single-clauses        ; sorting/filtering clause for single COLUMN
   #:reduce-clauses                ; sorting/filtering clause for query
   #:trigger-new-query             ; build & dispatch new query
       ;; header & popup menu
   #:checked-title                 ; add checkbox before column title
   #:uncheck-checked-title         ; remove checkbox from title string
   #:columns-with-selected         ; list nil for cols w/default selection, t otherwise
   #:view-columnheads              ; column definition for browser class
   #:refresh-columnheads           ; refresh headers by current sorting/filtering
   #:header-popup                  ; menu for COLUMN header by INTERFACE
   #:reset-query                   ; initialize sorting, filtering & whole browser
       ;; import, export & settings
   #:import-from-xlsx              ; ask for files, trigger import & RESET-QUERY
   #:export-to-xlsx                ; ask for file & save selected rows into it
   #:settings                      ; display window for updating settings
       ;; new & update
   #:input-mode                    ; determine window mode by MODUS & LENGTH
   #:input-window                  ; display input window
       ;; start
   #:header-callback               ; display HEADER-POPUP
   #:make-browser                  ; create a browser window



   ;; RTZ.LISP
   #:user-token                    ; short name of the current user
   #:start                         ; start the program



   ;; TEST.LISP
   #:row                           ; random person's data in a list
   #:print-row                     ; print in a form that fits Excel



   ;; SANDBOX.LISP
   #:*ctest-iterations*
   #:with-ctest-db
   #:ctest-init
   #:ctest
   #:test01
   ))
