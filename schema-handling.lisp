;;; -*- Msode: Common-Lisp; Author: denes.cselovszky@gmail.com -*-
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; Utilities


(defun select-table (table)
  "Get TABLE's sub-plist from SCHEMA."
  (find-if #'(lambda (record) (eq (getf record :table) (string->symbol table)))
           (getf *schema* :tables)))

(defun select-column (column table)
  "Get COLUMN's sub-plist from TABLE's sub-plist from SCHEMA."
  (find-if #'(lambda (record) (eq (getf record :column) (string->symbol column)))
           (getf (select-table (string->symbol table)) :columns)))

(defun find-io-mapping-if (predicate)
  "Find import that satisfies PREDICATE."
  (find-if predicate (getf *schema* :io-mappings)))

(defun default-io-mapping ()
  "Name of the default import."
  (getf (find-io-mapping-if #'(lambda (import) (getf import :default-p))) :name))

(defun io-mapping (&optional (name nil))
  "Return the mapping for IMPORT."
  (getf (find-io-mapping-if #'(lambda (import)
                                (eq (getf import :name)
                                    (or name (default-io-mapping)))))
        :mapping))

(defun map-io (header-names &optional (mapping nil))
  "Substitute import file header names to schema column names."
  (let ((mapping* (io-mapping (or mapping (default-io-mapping)))))
    (if mapping*
      (loop for name in header-names
            for mapn = (car (find name mapping* :test #'string= :key #'second))
            collecting mapn into results
            collecting (if mapn nil name) into fails
            finally (return (values results fails)))
      (values nil nil))))

(defun column-impersonal (column table)
  "Tell whether column in mass-updateable."
  (getf (select-column column table) :impersonal))

(defun io-columns (table &optional (mapping nil))
  "List all columns in TABLE that has an :IMPORT value in SCHEMA."
  (let ((mapping (mapcar #'first (io-mapping mapping)))
        (columns (mapcar #'(lambda (column) (getf column :column))
                         (getf (select-table table) :columns))))
    (remove-if-not #'(lambda (column)
                       (find column mapping))
                   columns)))

(defun schema-transl ()
  "Default translation selector label for the schema."
  (getf *schema* :transl))

(defun table-transl (table)
  "Default translation selector label for TABLE."
  (or (getf (select-table table) :transl)
      (schema-transl)))

(defun foreign-columns (table)
  "List all columns in TABLE that doesn't have an :IMPORT value in SCHEMA."
  (remove-if #'(lambda (column)
                 (or (getf column :import)
                     (and (search '(primary key)
                                  (getf column :desc)))))
             (getf (select-table table) :columns)))

(defun new-only-p (table)
  "Returns T if TABLE should contain unique records."
  (getf (select-table table) :new-only))


;;; ----------------------------------------------------------------------
;;; SQL


(defun schema-tables ()
  "List names of all tables defines in SCHEMA."
  (mapcar #'(lambda (table) (getf table :table))
          (getf *schema* :tables)))

(defun schema-columns (table)
  "List names of columns in TABLE."
  (mapcar #'(lambda (column) (getf column :column))
          (getf (select-table table) :columns)))

(defun column-description (column table)
  "List keywords describing COLUMN in TABLE."
  (getf (select-column column table) :desc))

(defun many-joins (table)
  "List joins defined for many-table TABLE."
  (remove-if-not #'(lambda (record) (eq (first record) (string->symbol table)))
                 (getf *schema* :connections)))

(defun all-connections (accessor)
  "List all individual elements of the connection field."
  (remove-duplicates
   (mapcar accessor (getf *schema* :connections))))

(defun one-tables ()
  "List all 'one' tables from SCHEMA."
  (all-connections #'second))

(defun many-tables ()
  "List all 'many' tables from SCHEMA."
  (all-connections #'first))

(defun immd-worker (column list)
  "Worker fn for IMMEDIATE-P and FOREIGN-P."
  (member column list :key #'(lambda (rec) (getf rec :column))))
  
(defun immediate-p (column table)
  "Does COLUMN have an I/O key?"
  (member column (io-columns table)))

(defun foreign-p (column table)
  "Is COLUMN without an I/O key?"
  (immd-worker column (foreign-columns table)))

(defun primary-key-p (column table)
  "Returns T if COLUMN is TABLE's primary key."
  (search '(primary key)
          (getf (select-column column table) :desc)))

(defun foreign-table (table column)
  "Foreign table linked to TABLE by key COLUMN."
  (second (find-if #'(lambda (row)
                       (eq column (third row)))
                   (many-joins table))))

(defun column-transl (table column)
  "Translation selector label for COLUMN in TABLE."
  (or (getf (select-column column table) :transl)
      (table-transl table)))

(defun table (column &key (primary-key-allowed nil) (foreign-allowed nil))
  "What table does COLUMN appear in?"
  (let ((results '())
        (column* (string->symbol column)))
    (dolist (table (schema-tables))
      (when (and (member column* (schema-columns table))
                 (or (and (not (primary-key-p column* table))
                          (not (foreign-p column* table)))
                     (and (primary-key-p column* table)
                          primary-key-allowed)
                     (and (foreign-p column* table)
                          foreign-allowed)))
        (push table results)))
    (remove-duplicates results)))


;;; ----------------------------------------------------------------------
;;; Import


(defun column-import (column mapping)
  "Spreadsheet column to import value for COLUMN. MAPPING must be the result of IMPORT-MAPPING."
  (second (find column mapping :key #'first)))

(defun root-table ()
  "Return the name of the root table of *SCHEMA*."
  (getf *schema* :root))

(defun primary-key (table)
  "What column is the primary key of TABLE?"
  (find-if #'(lambda (column)
               (primary-key-p column table))
           (schema-columns table)))


;;; ----------------------------------------------------------------------
;;; GUI


(defun view (view)
  "Return view named VIEW."
  (getf (getf *schema* :views) view))

(defun view-id (view)
  "Return id column name for VIEW."
  (getf (view view) :id))

(defun view-data (view)
  "Helper fn for VIEW-COLUMNS & VIEW-LABELS."
  (getf (view view) :columns))

(defun view-columns (view)
  "Return columns of VIEW."
  (mapcar #'first (view-data view)))

(defun view-labels (view)
  "Return column labels of VIEW."
  (mapcar #'second (view-data view)))

(defun view-colwidths (view)
  "Return column widths of VIEW."
  (mapcar #'third (view-data view)))

(defun view-order (view)
  "Return the default ordering for VIEW."
  (getf (view view) :order))

(defun column-type (column table)
  "Determine type of COLUMN in TABLE."
  (destructuring-bind (&key type desc &allow-other-keys)
      (select-column column table)
    (cond ((eq type :date) type)
          ((member 'text desc) :string)
          ((member 'integer desc) :integer)
          (t nil))))

(defun view-impersonal (view)
  "List impersonal columns from VIEW."
  (remove-if #'(lambda (column)
                 (let ((first (first column)))
                   (not (column-impersonal first (first (table first :foreign-allowed t))))))
             (view-data view)))
