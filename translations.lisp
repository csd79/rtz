;;; -*- Msode: Common-Lisp; Author: denes.cselovszky@gmail.com -*-
                                                                              ;

(in-package #:rtz)


;;; ----------------------------------------------------------------------
;;; Translators


(deftranslators *rtz-translators*
#|  ;; Lisp -> SQL --------------------------------------
  (:src  "lisp"
   :dst  "sql"
   :type string
   :fn   (str (format nil "~a" (clean-name str :capitalize nil))))|#



  ;; Excel -> IMPORT.LISP/COLLECT-ROW-VALUES ----------
  ;; <hudate-parsable>  =>  "2025-11-25"
  ;; <empty-cell>       =>  "NULL"
  ;; <other-values>     =>  <other-values>
  (:src  "xl"
   :dst  "prg"
   :type t
   :fn   (val val))

  (:src  "xl"
   :dst  "prg"
   :type empty-cell
   :fn   (val "NULL"))

#|  (:src  "xl"
   :dst  "prg"
   :type hudate-parsable
   :fn   (str (hudate->sql (parse-hudate str))))|#



  ;; Schema -> columns --------------------------------
  ;; ...
  (:src  "sch"
;   :dst  ""
   :type t
   :fn   (val val))

  (:src  "sch"
;   :dst  ""
   :type string
   :fn   (str (clean-name str :capitalize nil)))

  (:src  "sch"
   :dst  "tk"
   :type string
   :fn   (str (concatenate 'string (first (str:words str))
                           " Tankerületi Központ")))

  (:src  "sch"
   :dst  "date"
   :type hudate-parsable
   :fn   (str (hudate->sql (parse-hudate str))))

   (:src  "sch"
    :dst  "date"
    :type number
    :pred (num (zerop (mod num 1)))
    :fn   (num (hudate->sql (excel-date num))))


  ;; SQL.LIST/CLAUSE (SELECT/UPDATE) -> SQLite --------
  ;; (:@vals 1 2 3)              =>  "1, 2, 3"
  ;; (:vals 1 2 3)               =>  "(1, 2, 3)"
  ;; '("str" sym (:vals 1 2 3))  =>  '("'str'" "SYM" "(1, 2, 3)")
  ;; "string"                    =>  "'string'"
  ;; 'symbol                     =>  "SYMBOL"
  ;; <values-of-other-types>     =>  <values-of-other-types>
  (:src  "prg"
   :dst  "sql"
   :type t
   :fn   (val val))

  (:src  "prg"
   :dst  "sql"
   :type symbol
   :fn   (sym (symbol-name sym)))

  (:src  "prg"
   :dst  "sql"
   :type string
   :fn   clean-str-sql)
;   :fn   (str (clean-str-sql str)))

  (:src  "prg"
   :dst  "sql"
   :type list
   :fn   (list (mapcar #'(lambda (elem) (transl elem "prg>sql")) list)))

  (:src  "prg"
   :dst  "sql"
   :type value-list
   :fn   (list (sql-list (transl (rest list) "prg>sql") :parens t)))

  (:src  "prg"
   :dst  "sql"
   :type enclosed-value-list
   :fn   (list (sql-list (transl (rest list) "prg>sql") :parens nil))) 

  )


;;; ----------------------------------------------------------------------
;;; Synonyms


(defparameter *rtz-syns* '(
  ("Tankerületi Központ" "TK" "Tk")
  ))
