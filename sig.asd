(defsystem "sig"
  :description "Application tracker for e-signature certifications"
  :author      "Denes Cselovszki <denes.cselovszky@gmail.com>"
  :version     "0.08"
  :depends-on  ("cffi" "iterate" "cl-ppcre" "local-time" "str" "achar" "ccom3" "msoffice" "sqlite" "wax")
  :serial      t
  :components  ((:file "package")
                (:file "fli-templates")
                (:file "globals")
                (:file "schema")
                (:file "utilities")
                (:file "sql")
                (:file "import")
                (:file "sig")
                (:file "sandbox")))
