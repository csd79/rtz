;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 

(in-package "CL-USER")
(load "c:\\Users\\cselovszkid\\.lispworks")
(asdf:load-system "rtz")

(in-package "RTZ")
(setf *independent-exe* t)
(lw:deliver 'start
    "c:\\Users\\cselovszkid\\common-lisp\\rtz\\rtz_v0.32.exe"
    5
    :interface :capi
    :console :io
    :multiprocessing t
    :icon-file "c:\\Users\\cselovszkid\\common-lisp\\rtz\\img\\ico2.ico"
    :startup-bitmap-file "c:\\Users\\cselovszkid\\common-lisp\\rtz\\img\\frieda640.bmp"
    :keep-symbols '(*appdir* *independent-exe*)
    :packages-to-keep-externals '(wax msoffice) ; fn-s called indirectly
    :keep-package-manipulation t
    :keep-function-name :all
    :keep-eval t
    :keep-lisp-reader t
    :symbol-names-action nil
    :startup-bitmap-file nil
    :kill-dspec-table nil
    :keep-conditions :all
    :keep-debug-mode t
    :keep-load-function t
    :compact t
    )
