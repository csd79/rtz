;;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 
                                                                              ;

(in-package #:sig)


;;; ----------------------------------------------------------------------
;;; Base layer


;;; :EXECUTE              : execute SQL statements
;;; :EXECUTE-AND-VERIFY   : execute SQL statements, dump the statements and results
;;; :VERIFYY              : dump statements without executing them
(defparameter *exec/verify* :execute)

(defparameter *statements-out* nil)

(defmacro verify-statements ((&key (execute t)) &body body)
  "After BODY, return a dump string containting statements (& results) generated in BODY."
  `(let ((*statements-out* (make-string-output-stream))
         (*exec/verify*    (if ,execute :execute-and-verify :verify)))
     ,@body
     (get-output-stream-string *statements-out*)))


(defun statement (control-string &rest params)
  "Construct statement by interpolating PARAMS into CONTROL-STRING."
  (apply #'format nil control-string params))


(defun sql->list (statement &optional (params nil))
  "Execute statement constructed from CONTROL-STRING and PARAMS,
   return results as a list."
  (let ((result (when (member *exec/verify* '(:execute :execute-and-verify))
                  (apply #'execute-to-list *db* statement params))))
    (when *statements-out*
      (format *statements-out*
              "~a" statement))
    result))


(defun sql->sv (statement &optional (params nil))
  "Execute statemtnt constructed from CONTROL-STRING and PARAMS,
   return results as a vector of lists."
  (let* ((tree   (sql->list statement params))
         (length (length tree))
         (result (make-array length)))
    (loop for i from 0 below length
          for e in tree doing
          (setf (svref result i) e))
    result))

(defparameter *sqlfn* #'sql->sv) ; #'sql->list


(defun column-definition (column table)
  "Create column definition SQL substatement."
  (str:unwords
   (mapcar #'sql-name
           (nconc (list column) (column-description column table)))))


(defun all-column-definitions (table)
  "Create column definition SQL substatements for all columns of TABLE."
  (mapcar #'(lambda (column)
              (column-definition column table))
          (schema-columns table)))


(defun literal-column-defs (sequence)
  "Reform literal column definitions in SEQUENCE for SQL-LIST."
  (mapcar #'(lambda (element)
              (cond ((or (stringp element)
                         (symbolp element))
                     element)
                    ((sequencep element)
                     (format nil "~{~a~^ ~}" (coerce element 'list)))
                    (t nil)))
          (rmapcar #'sql-name sequence)))


(defun param-pattern (cols rows)
  "Create a pattern of SQL parameters."
  (let ((one-row (sql-list (loop for c from 0 below cols collecting "?") :parens t)))
    (sql-list (loop for r from 0 below rows collecting one-row) :parens nil)))


;;; ----------------------------------------------------------------------
;;; Clauses


(defun col (column &optional table)
  "Create subclause 'TABLE.COLUMN'."
  (let ((table (if table (format nil "~a." (sql-name table)) "")))
    (intern (string-upcase 
             (format nil "~a~a" table (sql-name column))))))


(defun type-rewrites (list) ;;;;;;;;;;;;;;;;;;;;;;;;;   XVLA->SQL????????????????????
  "Transform elements of LIST as printed SQL values."
  (mapcar #'(lambda (element)
              (typecase element
                (list (cond ((eq (first element) :vals)
                             (sql-list (rest element) :parens t))
                            ((eq (first element) :@vals)
                             (sql-list (rest element) :parens nil))
                            (t (type-rewrites element))))
                (symbol (symbol-name element))
                (string (format nil "'~a'" element))
                (t element)))
          list))


(defun clause (name arg)
  "General worker for generating clauses."
  (let ((name-string (typecase name
                       (list (septd name :in-parens nil))
                       (symbol (symbol-name name))
                       (string name)
                       (t (error "'~a' is not a usable clause name." name)))))
    (septd (nconc (list (str:replace-all "-" " " name-string))
                  (if (listp arg)
                    (type-rewrites arg)
                    (list arg)))
           :in-parens nil)))


(defun clause-from (table)
  "Generate FROM clause."
  (clause :from (list table)))


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


(defun clause-where (filter-list)
  "Generate WHERE clause."
  (clause :where filter-list))


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


(defun clause-group-by (column)
  "Generate GROUP BY clause."
  (clause :group-by (list column)))


(defun clause-having (filter-list)
  "Generate HAVING clause."
  (clause :having filter-list))


(defun clause-limit (value)
  "Generate LIMIT clause."
  (clause :limit (list value)))


(defun clause-offset (value)
  "Generate OFFSET clause."
  (clause :offset (list value)))


;;; ----------------------------------------------------------------------
;;; Operations


(defun drop-table (name)
  "Drop table NAME in *DB*."
  (funcall *sqlfn* (statement "drop table ~a" name)))


(defun drop-all-tables ()
  "Drop all tables in *DB*."
  (dolist (table (existing-tables))
    (drop-table table)))


(defun table-info (table)
  "Return a list of columns descriptions for TABLE."
  (funcall *sqlfn* (statement "pragma table_info(~a)" table)))


(defun table-columns (table)
  "List the names of TABLE's columns."
  (mapcar #'second (table-info table)))


(defun db-info ()
  "Print the description of every table in DATABASE."
  (dolist (table (existing-tables))
    (format t "~%~%~a  -------------------------------------~%~{~a~%~}"
            table (table-info table))))


(defun dump-table (table)
  "Return the complete contents of TABLE in the form of a list."
  (let ((columns (table-columns table)))
    (if columns
      (funcall *sqlfn* (statement "select ~a from ~a"
                                  (sql-list columns :parens nil)
                                  table))
      (error "Table not found in db: ~a." table))))


(defun number-of-rows (table)
  "Return the number of rows in TABLE."
  (second (first (funcall *sqlfn* (statement "select ~s, count(*) from ~a"
                                             (first (table-columns table))
                                             table)))))


(defun create-table (name &optional (cols-arg nil))
  "Create table NAME in DB."
  (let ((columns (typecase cols-arg
                   (seq-of-seqs-of-strings-or-symbols (literal-column-defs cols-arg))
                   (seq-of-strings-or-symbols         (column-names cols-arg))
                   (t                                 (all-column-definitions name)))))
    (if columns
      (funcall *sqlfn* (statement "create table ~a ~a" name (sql-list columns :parens t)))
      (error "Couldn't create table ~a: list of columns is empty." name))))


(defun insert-into (table dest new-only &rest values)
  "Insert VALUES into COLUMNS of TABLE."
  (let* ((width  (if (sequencep dest) (length dest) 1))
         (length (length values))
         (height (round (/ length width)))
         (ignore (if new-only "OR IGNORE " "")))
    ;; If number of values doesn't correspond with number of columns => error.
    (unless (= length (* width height))
      (error "Numberof columns (~a) is in conflict with number of values (~a)." width length))
    ;; Operation.
    (funcall *sqlfn* (statement "insert ~ainto ~a ~a values ~a" ignore table
                                ;; List of destination columns.
                                (sql-list (if (= width 1)
                                            (list dest)
                                            dest)
                                          :parens t)
                                ;; Patern of ?s.
                                (param-pattern width height))
             values)))


(defun select (columns &key (distinct nil) (from nil)     (left-join nil) (where nil)
                            (order-by nil) (group-by nil) (having nil)
                            (limit nil)    (offset nil)   (inserts '()))
  "Select rows."
  (let* ((distinct*  (if distinct "distinct" ""))
         (columns*   (sql-list columns))
         (from*      (if from (clause-from from) ""))
         (left-join* (if left-join (clauses-left-join left-join) ""))
         (where*     (if where (clause-where where) ""))
         (order-by*  (if order-by (clause-order-by order-by) ""))
         (group-by*  (if group-by (clause-group-by group-by) ""))
         (having*    (if having (clause-having having) ""))
         (limit*     (if limit (clause-limit limit) ""))
         (offset*    (if offset (clause-offset offset) ""))
         (statement  (str:unwords (str:words
                       (statement "select ~a ~a ~a ~a ~a ~a ~a ~a ~a ~a"
                                  distinct* columns* from* left-join*
                                  where* group-by* having*
                                  order-by* limit* offset*)))))
    (funcall *sqlfn* statement inserts)))


;;; ----------------------------------------------------------------------
;;; Simple operations


(defun table (column &key (primary-key-allowed nil) (foreign-allowed nil))
  "What table does COLUMN appear in?"
  (let ((result  '())
        (column* (string->symbol column)))
    (dolist (table (schema-tables))
      (when (and (member column* (schema-columns table))
                 (or (and (not (primary-key-p column* table))
                          (not (foreign-p column* table)))
                     (and (primary-key-p column* table)
                          primary-key-allowed)
                     (and (foreign-p column* table)
                          foreign-allowed)))
        (push table result)))
    (remove-duplicates result)))


(defun qualified-p (column &key (strict nil) (missing-error nil))
  "Does COLUMN contain table name prefix? When STRICT: does 'table.column' exist in the schema?"
  (let* ((string (symbol->string column))
         (words  (str:split "." string)))
    (if (> (length words) 2)
      (error "Invalid qualified column name (multiple table names??): ~a" column)
      (and (= (length words) 2)
           (or (and strict
                    ;; Does 'table.column' exist in schema?
                    (let ((table-exists  (member (string->symbol (first words)) (schema-tables)))
                          (column-exists (member (string->symbol (second words))
                                                 (schema-columns (first words)))))
                      ;; If not and NON-STRICT-ERROR, signal error!
                      (if (and missing-error
                               (or (not table-exists)
                                   (not column-exists)))
                        (error "~a.~a does not exist in current schema." (first words) (second words))
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


(defun qualify (column &key (primary-key-allowed nil) (foreign-allowed nil) (non-column-allowed nil))
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
  "Tel if LIST's element at INDEX is a column name (based on surroundings)?"
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
          doing (if (consp current)
                  (push (where-columns current) columns)
                  (when (where-column-p tree index)
                    (push (list current) columns))))
    (mapcar #'unqualify (apply #'nconc columns))))


(defun qualify-where (tree)
  "Ensure qualified column names in a WHERE clause."
  ;;  (beosztas = 1 and orszagok.orszag < 2 or (szerv_egys > 6 and tank_kozpont = 5) and
  ;;      t_kapcs_eszkoz = 0)
  ;;          ->
  ;;  (BEOSZTASOK.BEOSZTAS = 1 AND ORSZAGOK.ORSZAG < 2 OR (SZERV_EGYSEGEK.SZERV_EGYS > 6 AND
  ;;      TANK_KOZPONTOK.TANK_KOZPONT = 5) AND T_KAPCS_ESZKOZOK.T_KAPCS_ESZKOZ = 0)
  (loop for index from 0 below (length tree)
        for current  = (nth index tree) 
        collecting (if (consp current)
                     (qualify-where current)
                     (if (and (where-column-p tree index)
                              (not (qualified-p current :strict t :missing-error t)))
                       (qualify (string->symbol current) :non-column-allowed t
                                :primary-key-allowed t
                                )
                       current))))


(defun from-tables (list)
  "Filter LIST to keep only tables that are not one-tables in schema."
  (let ((no-ones  (one-tables)))
    (remove-if #'(lambda (table)
                   (member table no-ones))
               list)))


(defun join-keys (root column)
  "Return a list of key columns that lead from ROOT to COLUMN (if any)."
  (labels ((f (root* column*)
             (if (member column* (schema-columns root*))
               ;; If ROOT table contains COLUMN, the chain ends.
               (list t)
               ;; Otherwise, if ROOT has possible left joins, evaluate them.
               (first (remove nil (mapcar #'(lambda (record)
                                              (let ((ret (f (second record) column*)))
                                                (when ret
                                                  (cons (third record) ret))))
                                          (many-joins root*)))))))
    (let ((result (f root column)))
      (butlast result))))


(defun sort-join-keys (list)
  "Sort keys in hierarchical order."
  (let ((all   (all-connections #'identity))
        (manys (many-tables)))
    (labels ((dig (key)
               (let ((many (first (find key all :key #'third))))
                 (if many
                   (1+ (dig (third (find many all :key #'second))))
                   0))))
      (sort list #'(lambda (x y) (<= (dig x) (dig y)))))))


(defun all-join-keys (from-tables all-collumns)
  "JOIN-KEYS for multiple routes."
  (let ((result '()))
    (dolist (column all-collumns)
      (dolist (table from-tables)
        (push (join-keys table column) result)))
    (sort-join-keys (delete-duplicates (apply #'nconc result)))))


(defun find-join (key)
  "Find the join that uses KEY."
  (find-if #'(lambda (record)
               (eq key (third record)))
           (getf *schema* :connections)))


(defun frills (columns where)
  "Calculate from tables, join clauses and the proper where clause."
  (let* ((where-columns  (where-columns where))
         (all-nq-columns (append columns where-columns))
         (all-tables     (delete-duplicates (apply #'nconc (mapcar #'(lambda (column)
                                                                       (table column
                                                                              :primary-key-allowed t
                                                                              :foreign-allowed t))
                                                                   all-nq-columns))))
         (from-tables    (from-tables all-tables))
         (join-keys      (all-join-keys from-tables all-nq-columns))
         (join-clauses   (mapcar #'find-join join-keys))
         (qwhere         (qualify-where where)))
    (values from-tables join-clauses qwhere)))
  


(defun select-simple (columns &key (where '()) (limit nil) (offset nil) (order-by '()))
                     ; (:group-by cols) :having col
  (multiple-value-bind (from-tables join-clauses qwhere)
      (frills columns where)
    (apply #'select
           (append (list columns :from from-tables :left-join join-clauses :where qwhere)
                   (when order-by
                     (list :order-by order-by))
                   (when limit
                     (list :limit limit))
                   (when offset
                     (list :offset offset))))))


(defun count-simple (columns &key (where '()))
  (multiple-value-bind (from-tables join-clauses qwhere)
      (frills columns where)
    (let ((result (select '("count(*)") :from from-tables :left-join join-clauses :where qwhere)))
      (first (elt result 0)))))


(defun select-simple-id-into-temp (columns &key (where '()) (order-by '()) (temp ""))
  "Create table TEMP and select COLUMN (presumably and id) into it."
  (unless (string= temp "")
    (let* ((select-substatement (verify-statements (:execute nil)
                                  (select-simple columns :where where :order-by order-by)))
           (full-statement      (format nil "create table ~a as ~a"
                                        temp
                                        select-substatement)))
      (funcall *sqlfn* full-statement))))


(defun select-simple-by-temp (columns &key (where '()) (temp "")    (id "")
                                           (limit nil) (offset nil) (order-by '()))
  "Select columns where row id is in TEMP."
  (declare (ignore where))
  (apply #'select-simple columns
         :order-by order-by
         :where `(,id in (select ,id from ,temp))
         (append (if limit (list :limit limit) '())
                 (if offset (list :offset offset) '()))))
