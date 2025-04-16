(defsystem "sig"
  :description "Application tracker for e-signature certifications"
  :author      "Denes Cselovszki <denes.cselovszky@gmail.com>"
  :version     "0.04"
  :depends-on  ("cffi" "iterate" "cl-ppcre" "local-time" "str" "achar" "ccom3" "msoffice" "sqlite" "wax")
  :serial      t
  :components  ((:file "package")
                (:file "fli-templates")

                (:file "utilities")
                (:file "schema")

                (:file "sql")
                (:file "import")
                
                (:file "sig")
                (:file "conctest")))
