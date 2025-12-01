;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; Base layer


;;; :EXECUTE              : execute SQL statements
;;; :EXECUTE-AND-VERIFY   : execute & dump SQL statements
;;; :VERIFYY              : dump statements without executing them
(defparameter *exec/verify* :execute)
(defparameter *statements-out* nil)

(defun sql-execute-p () (member *exec/verify* '(:execute :execute-and-verify)))

(defun sql-verify-p (&key (excl nil))
  (if excl
    (eq *exec/verify* :verify)
    (member *exec/verify* '(:execute-and-verify :verify))))

(defmacro verify-statements ((&key (execute t)) &body body)
  "After BODY, return a dump string containting statements (& results) generated in BODY."
  `(let ((*statements-out* (make-string-output-stream))
         (*exec/verify*    (if ,execute :execute-and-verify :verify)))
     (progn ,@body
       (get-output-stream-string *statements-out*))))

(defun statement (control-string &rest params)
  "Construct statement by interpolating PARAMS into CONTROL-STRING."
  (apply #'format nil control-string params))

(defmacro def-sqlfn (fn-name (var-statement var-params) &body body)
  (let ((var-result (gensym)))
    `(defun ,fn-name (,var-statement &optional (,var-params nil))
       (let ((,var-result nil))
         (unwind-protect 
             (when (sql-execute-p)
               (setf ,var-result (progn ,@body)))
           (progn
             (when (and *statements-out* (sql-verify-p))
               (format *statements-out* "~a ~a  ~a~2%"
                       ,var-statement (or ,var-params "")
                       (if (sql-verify-p :excl t) ""
                         (format nil "=>  ~a" ,var-result))))
             ,var-result))))))

(def-sqlfn sql->list (statement params)
  "Execute statement constructed from CONTROL-STRING and PARAMS,
   return results as a list."
  (apply #'execute-to-list *db* statement params))

(def-sqlfn sql->sv (statement params)
  "Execute statemtnt constructed from CONTROL-STRING and PARAMS,
  return results as a vector of lists."
  (let* ((tree   (sql->list statement params))
         (length (length tree))
         (result (make-array length)))
    (loop for i from 0 below length
          for e in tree doing
          (setf (svref result i) e))
    result))

(defparameter *sqlfn* #'sql->list) ; #'sql->sv

(defun column-def (column table)
  "Create column definition SQL substatement. Helper to COLUMN-DEFINITIONS.
   (column-definition 'email 'igenylesek)  =>  'email text not nul'"
  (str:unwords
   (mapcar #'sql-name
;           (nconc (list column) (column-description column table)))))
           (list* column (column-description column table)))))

(defun column-defs (table)
  "List column definition SQL substatements for all columns of TABLE.
   Helper to CREATE-TABLE."
  (mapcar #'(lambda (column)
              (column-def column table))
          (schema-columns table)))

(defun flat-column-defs (sequence)
  "Reform literal column definitions in SEQUENCE for SQL-LIST.
   (flat-column-defs '(a b (c d) (e f) g))  =>  ('a' 'b' 'c d' 'e f' 'g')"
  (mapcar #'(lambda (element)
              (cond ((or (stringp element)
                         (symbolp element))
                     element)
                    ((sequencep element)
                     (format nil "~{~a~^ ~}" (coerce element 'list)))
                    (t nil)))
          (rmapcar #'sql-name sequence)))

(defun param-pattern (cols rows)
  "Create a pattern of SQL parameters.
  (param-pattern 2 3)  =>  '(?, ?), (?, ?), (?, ?)'"
  (let ((one-row (sql-list (loop for c from 0 below cols collecting "?") :parens t)))
    (sql-list (loop for r from 0 below rows collecting one-row) :parens nil)))

(defun where= (columns values)
  "WHERE clause where every COLUMNS equal VALUES one by one."
  (let ((mains (mapcar #'(lambda (col val) (list col '= val 'and))
                       columns values)))
    (butlast (apply #'nconc mains))))

(defun select-same (table cols vals)
  (select (list (primary-key table))
          :from table :where (where= cols vals)))


;;; ----------------------------------------------------------------------
;;; Requesting infor about tables & the DB


(defun table-info (table)
  "Return a list of columns descriptions for TABLE."
;  (let ((*sqlfn* #'sql->list))
  (funcall *sqlfn* (statement "pragma table_info(~a)" table)))
;)

(defun table-columns (table)
  "List the names of TABLE's columns."
  (mapcar #'second (table-info table)))
#|  (mapcar #'(lambda (info)
              (intern (string-upcase (second info))))
          (table-info table)))|#

(defun dump-table (table)
  "Return the complete contents of TABLE in the form of a list."
  (let ((columns (table-columns table)))
    (if columns
      (funcall *sqlfn* (statement "select ~a from ~a"
                                  (sql-list columns :parens nil)
                                  table))
      (error "Table not found in db: ~a." table))))

#|(defun number-of-rows (table)
  "Return the number of rows in TABLE."
  (second (first (funcall *sqlfn* (statement "select ~s, count(*) from ~a"
                                             (first (table-columns table))
                                             table)))))|#
(defun number-of-rows (table)
  "Return the number of rows in TABLE."
  (cadar (funcall *sqlfn*
                  (statement "select ~s, count(*) from ~a"
                             (first (table-columns table))
                             table))))

(defun db-info ()
  "Print the description of every table in DATABASE."
;  (let ((*sqlfn* #'sql->list))
    (dolist (table (existing-tables))
      (format t "~%~%~a  -------------------------------------~%~{~a~%~}"
              table (table-info table) 'list)))
;)


;;; ----------------------------------------------------------------------
;;; Clauses for SELECT and UPDATE operations


(defun col (column &optional table)
  "Create subclause 'TABLE.COLUMN'."
  (let ((table (if table (format nil "~a." (sql-name table)) "")))
    (intern (string-upcase 
             (format nil "~a~a" table (sql-name column))))))

(defun clause (name arg)
  "General worker for generating clauses."
  (let ((name-string (typecase name
                       (list (septd name :in-parens nil))
                       (symbol (symbol-name name))
                       (string name)
                       (t (error "'~a' is not a usable clause name." name))))
        (transl      (transl arg "prg>sql")))
;    (septd (nconc (list (str:replace-all "-" " " name-string))
    (septd (list* (str:replace-all "-" " " name-string)
                  (if (listp transl) transl (list transl)))
           :in-parens nil)))

(defun clause-left-join (table-many table-one column-many &optional (column-one nil))
  "Generate LEFT JOIN clause."
  (clause :left-join (list table-one 'on (col column-many table-many) '=
                           (col (or column-one column-many) table-one))))

(defun clauses-left-join (list)
  "Generate multiple LEFT JOIN clauses."
  (format nil "~{~a~^ ~}"
          (mapcar #'(lambda (sublist)
                      (apply #'clause-left-join sublist))
                  list)))

(defun clause-order-by (ordering)
  "Generate ORDER BY clause."
  (labels ((worker (list)
             (when list
               (let* ((first  (symbol->string (first list)))
                      (second (symbol->string (second list)))
                      (accum  (if (and (second list)
                                       (member second '("asc" "desc") :test #'string-equal))
                                (format nil "~a ~a" first second)
                                first)))
                 (cons accum (worker (if (string= first accum)
                                       (cdr list)
                                       (cddr list))))))))
    (let* ((list*   (if (listp ordering) ordering (list ordering)))
           (strings (worker list*)))
      (clause :order-by (sql-list strings)))))

#|(defmacro defclause (name key list-p)
  "Define clause generator fns where the argument remains unprocessed."
  (let ((var (gensym)))
    `(defun ,name (,var) (clause ,key ,(if list-p `(list ,var) var)))))

(defclause clase-where    :where    nil)
(defclause clase-having   :having   nil)
(defclause clase-group-by :group-by t)
(defclause clase-from     :from     t)
(defclause clase-limit    :limit    t)
(defclause clase-offset   :offset   t)|#

#|(defun clause-where (filter-list)
  "Generate WHERE clause."
  (clause :where filter-list))

(defun clause-having (filter-list)
  "Generate HAVING clause."
  (clause :having filter-list))

(defun clause-group-by (column)
  "Generate GROUP BY clause."
  (clause :group-by (list column)))

(defun clause-from (table)
  "Generate FROM clause."
  (clause :from (list table)))

(defun clause-limit (value)
  "Generate LIMIT clause."
  (clause :limit (list value)))

(defun clause-offset (value)
  "Generate OFFSET clause."
  (clause :offset (list value)))|#


;;; ----------------------------------------------------------------------
;;; Operations
;;; These are table-specific.
;;; Column and value arguments are expected as lists.
;;; These generate textual statements and send them to SQLite.


(defun init-db ()
  "Initialize *DB* according to *SCHEMA*."
  (drop-all-tables)
  ;; Create empty tables
  (dolist (table (schema-tables))
    (create-table table))
  ;; Fill up tks.
  (dolist (tk (mapcar #'first *tk-synonyms*))
    (insert 'tank_kozpontok '(tank_kozpont) t tk)))


(defun drop-table (name)
  "Drop table NAME in *DB*."
  (funcall *sqlfn* (statement "drop table ~a" name)))

(defun drop-all-tables ()
  "Drop all tables in *DB*."
  (dolist (table (existing-tables))
    (drop-table table)))

(defun create-table (name &optional (cols-arg nil))
  "Create table NAME in DB."
  (let ((columns (typecase cols-arg
                   (seq-of-seqs-of-strings-or-symbols (flat-column-defs cols-arg))
                   (seq-of-strings-or-symbols         (column-names cols-arg t))
                   (t                                 (column-defs name)))))
    (if columns
      (funcall *sqlfn* (statement "create table ~a ~a" name (sql-list columns :parens t)))
      (error "Couldn't create table ~a: list of columns is empty." name))))

#|(defun insert (table dest new-only &rest values)
  "Insert translated VALUES into COLUMNS of TABLE."
  (let* ((width  (if (sequencep dest) (length dest) 1))
         (length (length values))
         (height (round (/ length width)))
         (ignore (if new-only "OR IGNORE " "")))
    ;; If number of values doesn't correspond with number of columns => error.
    (unless (= length (* width height))
      (error "Number of columns (~a) <> number of values (~a)." width length))
    ;; Translated values.
    (let ((transl (mapcar #'(lambda (col val)
                              (transl val (column-transl table col)))
                          (if (sequencep dest) dest
                            (make-list length :initial-element dest))
                          values)))
      ;; Operation.
      (funcall *sqlfn* (statement "insert ~ainto ~a ~a values ~a" ignore table
                                  ;; List of destination columns.
                                  (sql-list (if (= width 1)
                                              (list dest)
                                              dest)
                                            :parens t)
                                  ;; Patern of ?s.
                                  (param-pattern width height))
               transl))))|#
#|(defun insert (table dest new-only &rest values)
  "Insert translated VALUES into COLUMNS of TABLE."
  (let* ((width   (if (sequencep dest) (length dest) 1))
         (length  (length values))
         (height  (round (/ length width)))
         (ignore  (if new-only "OR IGNORE " ""))
         (error   (unless (= length (* width height))
                    (error "Number of columns (~a) <> number of values (~a)." width length)))
         (transl  (mapcar #'(lambda (col val)
                              (transl val (column-transl table col)))
                          (if (sequencep dest) dest
                            (make-list length :initial-element dest))
                          values))
         (dlist   (sql-list (if (= width 1) (list dest) dest) :parens t))
         (pattern (param-pattern width height)))
    (declare (ignore error))
    ;; Operation.
    (funcall *sqlfn*
             (statement "insert ~ainto ~a ~a values ~a" ignore table dlist pattern)
             transl)))|#
(defun insert (table dest new-only &rest values)
  "Insert translated VALUES into COLUMNS of TABLE."
  (let* ((width   (if (sequencep dest) (length dest) 1))
         (length  (length values))
         (height  (round (/ length width)))
         (ignore  (if new-only "OR IGNORE " ""))
         (error   (unless (= length (* width height))
                    (error "Number of columns (~a) <> number of values (~a)." width length)))
         (dlist   (sql-list (if (= width 1) (list dest) dest) :parens t))
         (pattern (param-pattern width height)))
    (declare (ignore error))
    ;; Operation.
    (funcall *sqlfn*
             (statement "insert ~ainto ~a ~a values ~a" ignore table dlist pattern)
             values)))

(defun select (columns &key (distinct nil) (from nil)     (left-join nil) (where nil)
                            (order-by nil) (group-by nil) (having nil)
                            (limit nil)    (offset nil)   (inserts '()))
  "Select rows."
  ;; Simple clauses, no processing needed
#|  (destructuring-bind (where* having* group-by* from* limit* offset*)
      (mapcar #'(lambda (val key list)
                  (if val (clause key (if list (list val) val)) ""))
              (list where having group-by from limit offset)
              '(:where :having :group-by :from :limit :offset)
              '(nil nil t t t t))|#
  (let* ((distinct*  (if distinct "distinct" ""))
         (columns*   (sql-list columns))
         (left-join* (if left-join (clauses-left-join left-join) ""))
         (order-by*  (if order-by  (clause-order-by order-by) ""))
#|         (where*     (if where (clause-where where) ""))
         (having*    (if having (clause-having having) ""))
         (group-by*  (if group-by (clause-group-by group-by) ""))
         (from*      (if from (clause-from from) ""))
         (limit*     (if limit (clause-limit limit) ""))
         (offset*    (if offset (clause-offset offset) ""))|#
         (where*     (if where     (clause :where    where)           ""))
         (having*    (if having    (clause :having   having)          ""))
         (group-by*  (if group-by  (clause :group-by (list group-by)) ""))
         (from*      (if from      (clause :from     (list from))     ""))
         (limit*     (if limit     (clause :limit    (list limit))    ""))
         (offset*    (if offset    (clause :offset   (list offset))   ""))
         (statement  (str:unwords (str:words
                                   (statement "select ~a ~a ~a ~a ~a ~a ~a ~a ~a ~a"
                                              distinct* columns* from* left-join*
                                              where* group-by* having*
                                              order-by* limit* offset*)))))
      (funcall *sqlfn* statement inserts)));)

(defun cols=vals (columns values)
  "Generate subexpression COL1=VAL1, COL2=VAL2..."
  (format nil "~{~a~^, ~}"
          (mapcar #'(lambda (col val)
                      (format nil "~a=~a" col
                              (if (stringp val)
                                (format nil "~C~a~C" #\" val #\")
                                val)))
                  columns values)))

(defun update (table idcol ids destination &rest values)
  "Replace values in COLUMNS with VALUES in rows identified by IDS."
  (let* ((destlist (if (sequencep destination) destination (list destination)))
         (collen   (length destlist))
         (vallen   (length values))
         (filter   (if (sequencep ids)
                   `(,idcol in (:vals ,@ids))
                   `(,idcol = ,ids))))
    ;; If number of values doesn't correspond with number of columns => error.
    (unless (= collen vallen)
      (error "Numberof columns (~a) does not equal number of values (~a)." collen vallen))
    ;; Operation
    (funcall *sqlfn* (statement "update ~a set ~a ~a"
                                table
                                (cols=vals destlist values)
                                (clause-where filter)))))


;;; ----------------------------------------------------------------------
;;; Helper function halo for smart-select & smart-update
;;; This functions implement the mechanism that will qualify
;;; any unqualified column references & also fill in the join clause.


(defun qualified-p (column &key (strict nil) (missing-error nil))
  "Does COLUMN contain table name prefix? When STRICT: does 'table.column' exist in the schema?"
  (let* ((string (symbol->string column))
         (words  (str:split "." string)))
    (if (> (length words) 2)
      (error "Invalid qualified column name (multiple table names??): ~a" column)
      (and (= (length words) 2)
           (or (and strict
                    ;; Does 'table.column' exist in schema?
                    (let ((table-exists  (member (string->symbol (first words))
                                                 (schema-tables)))
                          (column-exists (member (string->symbol (second words))
                                                 (schema-columns (first words)))))
                      ;; If not and NON-STRICT-ERROR, signal error!
                      (if (and missing-error
                               (or (not table-exists)
                                   (not column-exists)))
                        (error "~a.~a does not exist in current schema."
                               (first words) (second words))
                        (and table-exists column-exists))))
               (not strict))))))


(defun unqualify (column)
  "Remove table qualification from column name."
  (if (qualified-p column)
    ;; COLUMN is qualified:
    (let* ((string (symbol->string column))
           (words  (str:split "." string))
           (result (case (length words)
                     (2 (second words))
                     (t (error "Invalid qualidied column name: ~a" column)))))
      (typecase column
        (symbol (string->symbol result))
        (string (symbol->string result))))
    ;; COLUMN is not qualified, return as it is:
    column))


(defun qualify (column &key (primary-key-allowed nil) (foreign-allowed nil)
                       (non-column-allowed nil))
  "Qualify COLUMN name adding table prefix."
  (let* ((column* (unqualify column))
         (table   (table column*
                         :primary-key-allowed primary-key-allowed
                         :foreign-allowed foreign-allowed))
         (fn      (if (symbolp column*) #'string->symbol #'symbol->string)))
    (if table
      (funcall fn (apply #'format nil "~a.~a"
                         (mapcar #'symbol->string (list (first table) column*))))
      (if non-column-allowed
        column
        (error "~a: no such column in any table in schema." column)))))


(defun where-column-p (list index)
  "Tell if LIST's element at INDEX is a column name (based on surroundings)?"
  (let ((previous (when (> index 0) (nth (1- index) list)))
        (next (when (< index (1- (length list))) (nth (1+ index) list))))
    (or (zerop index)
        (and previous (member previous '(or and not))
             next     (member next '(= in like between < > <> != <= >=))))))


(defun where-columns (tree)
  "Extract column names from a WHERE clause tree."
  (let ((columns '()))
    (loop for index from 0 below (length tree)
          for current = (nth index tree)
;          doing (if (consp current)
          doing (if (and (consp current)
                         (not (typep current 'value-list)))
                  (push (where-columns current) columns)
                  (when (where-column-p tree index)
                    (push (list current) columns))))
    (mapcar #'unqualify (apply #'nconc columns))))
;    (mapcar #'unqualify (apply #'append columns))))


(defun update-src (label src)
  "When SRC is not an empty string, update the source part of LABEL to SRC."
  (check-type src string)
  (if (string= src "")
    label
    (multiple-value-bind (old-src trg)
        (transl::destruct-label label)
      (declare (ignore old-src))
      (concatenate 'string src ">" trg))))


(defun column-transl-label (column &key (src ""))
  "Return the translation label specific for COLUMN, with it's source updated to SRC."
  (let* ((table  (first (table column :foreign-allowed t)))
         (label  (column-transl table column)))
    (update-src label src)))


(defun transl-vals (list index src)
  "LIST element on position INDEX is a value list. Return it with it's values translated."
  (when (>= index 2)
    (let* ((column (unqualify (nth (- index 2) list)))
#|           (table  (first (table column :foreign-allowed t)))
           (label  (column-transl table column))
           (label* (update-src label src)))|#
           (label* (column-transl-label column src)))
      (list* :vals (mapcar #'(lambda (value)
                               (transl value label*))
                           (rest (nth index list)))))))


(defun where-value-p (list index)
  "Determine if element of LIST at position INDEX is a value for a :WHERE clause."
  ;; It is a value if it is not the first element and either...
  (and (not (zerop index))
       (or ;;...the previous element is a relational operator
           (member (nth (1- index) list) '(= <> != < > <= >= like between))
           ;;...the third previous element is 'between'
           (and (>= index 3) (eq (nth (- index 3) list) 'between)))
       t))

  
(defun transl-where-value (list index src)
  "Perform column-specific translation on value at position INDEX in LIST."
  (let* ((column-index
          ;; If previous is a relational op, column is the 2nd previous element
          (cond ((and (>= index 2)
                      (member (nth (1- index) list) '(= <> != < > <= >= like between)))
                 (nth (- index 2) list))
                ;; If 3rd previous is 'between', column is the 4th previous
                ((and (>= index 4)
                      (eq (nth (- index 3) list) 'between))
                 (nth (- index 4) list))
                (t nil)))
         ;; Determine label for column
         (column (when (integerp column-index) (unqualify (nth column-index list))))
#|         (table  (first (table column :foreign-allowed t)))
         (label  (column-transl table column))
         (label* (update-src label src)))|#
         (label* (column-transl-label column src)))
    ;; Do the translation
    (transl (nth index  list) label*)))


#|(defun qualify-where (tree)
  "Ensure qualified column names in a WHERE clause."
  ;;  (beosztas = 1 and orszagok.orszag < 2 or (szerv_egys > 6 and tank_kozpont = 5) and
  ;;      t_kapcs_eszkoz = 0)
  ;;          =>
  ;;  (BEOSZTASOK.BEOSZTAS = 1 AND ORSZAGOK.ORSZAG < 2 OR (SZERV_EGYSEGEK.SZERV_EGYS > 6 AND
  ;;      TANK_KOZPONTOK.TANK_KOZPONT = 5) AND T_KAPCS_ESZKOZOK.T_KAPCS_ESZKOZ = 0)
  (loop for index from 0 below (length tree)
        for current  = (nth index tree) 
        collecting (if (consp current)
                     ;; If element is an embedded list, recursive call
                     (qualify-where current)
                     ;; Else, if element is a non-qualified column name, qualify it
                     (if (and (where-column-p tree index)
                              (not (qualified-p current :strict t :missing-error t)))
                       (qualify (string->symbol current) :non-column-allowed t
                                :primary-key-allowed t
                                )
                       ;; If it is not, take it unmodified.
                       current))))|#
(defun rewrite-where (list src)
  "Ensure qualified column names in a WHERE clause."
  ;;  (beosztas = 1 and orszagok.orszag < 2 or (szerv_egys > 6 and tank_kozpont = 5) and
  ;;      t_kapcs_eszkoz = 0)
  ;;          =>
  ;;  (BEOSZTASOK.BEOSZTAS = 1 AND ORSZAGOK.ORSZAG < 2 OR (SZERV_EGYSEGEK.SZERV_EGYS > 6 AND
  ;;      TANK_KOZPONTOK.TANK_KOZPONT = 5) AND T_KAPCS_ESZKOZOK.T_KAPCS_ESZKOZ = 0)
#|  (loop for index from 0 below (length list)
        for current = (nth index list) collecting|#
  (loop for index from 0
        for current in list collecting
        (cond ;; When current element is...
         ;; ...a value list, translate its elements
         ((typep current 'value-list)
          (transl-vals list index src))
          ;; ...an embedded list, rewrite it on its own
         ((consp current) (rewrite-where current src))
         ;; ...a non-qualified column name, qualify it
         ((and (where-column-p list index)
               (not (qualified-p current :strict t :missing-error t)))
          (qualify (string->symbol current) :non-column-allowed t
                   :primary-key-allowed t))
         ;; ...a value, translate it
         ((where-value-p list index)
          (transl-where-value list index src))
         ;; ...something else, keep it as it is.
         (t current))))


(defun from-tables (list)
  "Filter LIST to keep only tables that are not one-tables in schema."
  (let* ((no-ones     (one-tables))
         (from-tables (remove-if #'(lambda (table)
                                     (member table no-ones))
                                 list)))
    ;; If there are no columns from the root table in the subject columns for select,
    ;; this might return an empty list and SMARTY will not generate 'from' and joins.
    (if (member (root-table) from-tables)
      from-tables
      (append (list (root-table)) from-tables))))


(defun join-keys (root column)
  "Return a list of key columns that lead from ROOT to COLUMN (if any)."
  (labels ((traverse (root* column*)
             (if (member column* (schema-columns root*))
               ;; If ROOT table contains COLUMN, the chain ends.
               (list t)
               ;; Otherwise, if ROOT has possible left joins, evaluate them.
               (first (remove nil (mapcar #'(lambda (record)
                                              (let ((ret (traverse (second record) column*)))
                                                (when ret
                                                  (cons (third record) ret))))
                                          (many-joins root*)))))))
    (let ((result (traverse root column)))
      (butlast result))))


(defun sort-join-keys (list)
  "Sort keys in hierarchical order."
  (let ((all (all-connections #'identity)))
;        (manys (many-tables)))
    (labels ((dig (key)
               (let ((many (first (find key all :key #'third))))
                 (if many
                   (1+ (dig (third (find many all :key #'second))))
                   0))))
      (sort list #'(lambda (x y) (<= (dig x) (dig y)))))))


(defun all-join-keys (from-tables collumns)
  "JOIN-KEYS for multiple routes."
  (let ((result '()))
    (dolist (column collumns)
      (dolist (table from-tables)
        (push (join-keys table column) result)))
    (sort-join-keys (delete-duplicates (apply #'nconc result)))))


(defun find-join (key)
  "Find the join that uses KEY."
  (find key (getf *schema* :connections) :key #'third))


(defun smarty (columns where src)
  "Calculate from tables, join clauses and the proper where clause."
  (let* ((where-columns  (where-columns where))
         (all-nq-columns (append columns where-columns))
         (all-tableses   (mapcan #'(lambda (column)
                                     (table column :primary-key-allowed t
                                            :foreign-allowed t))
                                 all-nq-columns))
         (from-tables    (from-tables (delete-duplicates all-tableses)))
;         (from-tables    (append (list (root-table)) (from-tables (delete-duplicates all-tableses))))
         (join-keys      (all-join-keys from-tables all-nq-columns))
         (join-clauses   (mapcar #'find-join join-keys))
#|         (qwhere         (qualify-where where)))
    (values from-tables join-clauses qwhere)))|#
         (new-where      (rewrite-where where src)))
    (values from-tables join-clauses new-where)))


;;; ----------------------------------------------------------------------
;;; Auto-resolve operations between multiple tables
;;; Argument lists are treated as targeting a single table containing all data.
;;; These functions will translate the operations for specific tables
;;; based on *SCHEMA*.


(defun resolve-column (column columns values)
  "Helper for RESOLVE-TABLE, constructs subtree for COLUMN."
  ;; POS: is there a value for COLUMN provided in VALUES?
  ;; TABLE: the one that has COLUMN as a foreign key
  (let ((pos   (position column columns))
        (table (first (table column :foreign-allowed t))))
    ;; If COLUMN is an immediate value & not a key:
    ;; => (:COLUMN <collumn> <val>) when value is provided
    (if (immediate-p column table)
      (when pos `(:column ,column ,(nth pos values)))
      ;; If COLUMN isn't immediate:
      ;; => (:COLUMN <column> (:TABLE <subtree...>)) when subtree
      (let ((result (resolve-table (foreign-table table column)
                                   columns values)))
        (when result `(:column ,column ,result))))))

(defun resolve-table (table columns values)
  "Construct a tree that describes columns and their values, plus
   their links across tables. RESOLVE-INSERT-NEW will perform
   insert-calls guided by this tree. Example:
     (:TABLE IGENYLESEK
       (:COLUMN SZEMELY_ID     ; foreign key linking IGENYLESEK & SZEMELYEK
         (:TABLE SZEMELYEK     ; inside SZEMELYEK, some immediate values:
           (:COLUMN VISELT_CSALADNEV 'Wayne')
           (:COLUMN VISELT_UTONEV_1 'Bruce') ...)) ...)"
  ;; For every column in TABLE except the primary key:
  ;; make a list of column subtrees.
  (let ((subtrees (loop for current in (schema-columns table)
                        for subtree = (unless (primary-key-p current table)
                                        (resolve-column current columns values))
                        when subtree collect subtree)))
    ;; => (:TABLE <table> <subtrees...>)  or  NIL if there were no subtrees.
    (when subtrees `(:table ,table ,@subtrees))))

(defun smart-resolve (tree op &optional (test nil))
  "Insert values into tables. The guiding TREE must be generated
   using RESOLVE-TABLE."
  (flet ((body ()
           (let ((table (second tree)))
             ;; For each column:
             ;; - If value is a subtree, resolve it first
             ;; - Then collect names and values
             ;; - Finally, insert row into TABLE & return the new row ID
             (loop for row in (cddr tree)
                   for exp = (third row)
                   for val = (if (consp exp) (smart-resolve exp op test) exp)
                   collecting (second row) into columns
                   collecting val into values
                   finally (return (funcall op table columns values))))))
    (if test
      (when (funcall test tree) (body))
      (body))))

(defun smart-context (list src op-fn &optional (test-fn nil))
  "Mid layer between the RESOLVE-fns and OP-FN."
  (with-db-context
    (with-transl (*rtz-translators* :verify nil)
      (let (
            ;(*sqlfn* #'sql->list)
            (cols    (mapcar #'first list))
            (vals    (mapcar #'(lambda (pair)
                                 (let* ((column (unqualify (first pair)))
#|                                      (table  (first (table column :foreign-allowed t)))
                                      (label  (column-transl table column))
                                      (label* (update-src label src)))|#
                                        (label* (column-transl-label column :src src)))
                                   (transl (second pair) label*)))
                             list)))
        (smart-resolve
         (resolve-table (root-table) cols vals)
         op-fn test-fn)))))


;;; ----------------------------------------------------------------------
;;; Smart operations
;;; They ensure a live DB context, execute pre-op test (insert) and
;;; fill in column qualifiers & the join clause. The also disseminate
;;; values into the corresponding tables according to the schema.


(defun smart-select (columns &key (where '()) (limit nil) (offset nil)
                             (order-by '()) (distinct nil) (src ""))
                     ; (:group-by cols) :having col
  (with-db-context 
    (with-transl (*rtz-translators* :verify nil)
      ;; Source tables, join clauses, where with qualified column names
      (multiple-value-bind (from-tables join-clauses qwhere)
          (smarty columns where src)
        (apply #'select
;             (append (list columns :from from-tables :left-join join-clauses :where qwhere)
               (nconc (list columns :distinct distinct :from from-tables
                            :left-join join-clauses :where qwhere)
                      (when order-by (list :order-by order-by))
                      (when limit    (list :limit limit))
                      (when offset   (list :offset offset))))))))


#|(defun count-simple (columns &key (where '()))
  (multiple-value-bind (from-tables join-clauses qwhere)
      (frills columns where)
    (let ((result (select '("count(*)") :from from-tables :left-join join-clauses :where qwhere)))
      (first (elt result 0)))))|#


(defun select-id->temp (column &key (where '()) (order-by '()) (temp ""))
  "Create table TEMP and select COLUMN (presumably an id) into it."
  (unless (string= temp "")
    (let* ((select-substatement (verify-statements (:execute nil)
                                  (smart-select column :where where
                                                :order-by order-by)))
           (full-statement      (format nil "create table ~a as ~a"
                                        temp select-substatement)))
      (funcall *sqlfn* full-statement))))


(defun select-by-temp (columns &key (where '()) (temp "")    (id "")
                               (limit nil) (offset nil) (order-by '()))
  "Select columns where row id is in TEMP."
  (declare (ignore where))
  (apply #'smart-select columns
         :order-by order-by
         :where `(,id in (select ,id from ,temp))
#|         (append (if limit (list :limit limit) '())
                 (if offset (list :offset offset) '()))))|#
         (nconc (when limit (list :limit limit))
                (when offset (list :offset offset)))))


(defun smart-insert (list src)
  (smart-context list src
   ;; Op function
   #'(lambda (table columns values)
       (apply #'insert table columns t values)
       (caar (select-same table columns values)))
   ;; Test function
   #'(lambda (tree)
       (destructuring-bind (key table &rest rest) tree
         (declare (ignore rest))
         (if (and (eq key :table) (eq table (root-table)))
           ;; If current table is the root, further examination is needed
           (loop for e in (cddr tree)
                 for third = (third e)
                 when (atom third)
                 collect (second e) into cols and
                 collect third into vals
                 ;; If provided values exist in root table, cancel
                 finally (return (null (select-same table cols vals))))
           ;; Otherwise, carry on with the resolve
           t)))))

(defun smart-update (ids list src)
  (smart-context list src
   #'(lambda (table columns values)
       ;; Op fn will be called on parent tables without updateable
       ;; columns, hence we have to check if VALUES are not NILs.
       (let ((values* (remove nil values))
             (ids*    (remove nil ids)))
         (when (and values* ids*)
           (apply #'update table (primary-key table) ids*
                  columns values*))))))


;;; ----------------------------------------------------------------------
;;; Tests


(defun ss ()
  (verify-statements (:execute t)
  (with-transl (*rtz-translators* :verify nil)
    (print (smart-select '(telefon email varos) :where '(igenyles_id in (:vals 417 418))));ok
    (print (smart-select '(telefon email) :where '(varos = "Budapest")));ok
    (print (smart-select '(telefon email varos) :where '(varos in (:vals "Budapest" "Esztergom"))));ok
    (print (smart-select '(varos) :distinct t :where '(tank_kozpont in (:vals "Ceglédi TK" "Pápai TK"))))
    ))
)

