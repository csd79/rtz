(defsystem "rtz"
  :description "Application tracker for e-signature certifications"
  :author      "Denes Cselovszki <denes.cselovszky@gmail.com>"
  :version     "0.32"
  :depends-on  ("cffi" "iterate" "cl-ppcre" "local-time" "str" "achar" "transl" "edit-distance" "ccom3" "msoffice" "sqlite" "wax")
  :serial      t
  :components  ((:file "package")
                (:file "fli-templates")
                (:file "globals")
                (:file "schema")
                (:file "utilities")
                (:file "schema-handling")
                (:file "translations")
                (:file "sql")
                (:file "import")
                (:file "gui")
                (:file "rtz")
                (:file "test")
                (:file "sandbox")))
