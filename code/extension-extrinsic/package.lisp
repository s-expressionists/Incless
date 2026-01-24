;;;; package.lisp

(defpackage #:incless-extension-extrinsic
  (:use #:cl)
  (:shadow #:pprint
           #:prin1
           #:prin1-to-string
           #:princ
           #:princ-to-string
           #:print
           #:print-object
           #:print-unreadable-object
           #:write
           #:write-to-string)
  (:export #:*client*
           #:extrinsic-client
           #:pprint
           #:prin1
           #:prin1-to-string
           #:princ
           #:princ-to-string
           #:print
           #:print-object
           #:print-unreadable-object
           #:write
           #:write-to-string))
