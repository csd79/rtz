(defsystem "sig"
  :description "Application tracker for e-signature certifications"
  :author      "Denes Cselovszki <denes.cselovszki@gmail.com>"
  :version     "0.01"
  :depends-on  ("cffi" "iterate" "cl-ppcre" "local-time" "str" "achar" "sxql" "ccom3" "msoffice" "sqlite" "wax")
  :serial      t
  :components  ((:file "package")
                (:file "fli-templates")
                (:file "sig")))
