;;; -*- Mode: Common-Lisp; Author: denes.cselovszky@gmail.com -*- 

(in-package "CL-USER")
(load "c:\\Users\\cselovszkid\\.lispworks")
(asdf:load-system "sig")

(in-package "SIG")
(setf *independent-exe* t)
(lw:deliver 'start
    "c:\\Users\\cselovszkid\\common-lisp\\sigorum\\sig_v0.05.exe"
    5
    :interface :capi
    :console :io
    :multiprocessing t
    :icon-file "c:\\Users\\cselovszkid\\common-lisp\\sigorum\\img\\sigorum.ico"
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
