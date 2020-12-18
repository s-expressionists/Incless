;;;; package.lisp

(defpackage #:incless
  (:use #:cl)
  (:shadow #:print-object #:write #:prin1 #:print #:pprint #:princ
           #:write-to-string #:prin1-to-string #:princ-to-string
           #:print-unreadable-object)
  (:local-nicknames (#:a #:alexandria))
  (:export #:print-oject #:print-object-using-client #:client
           #:standard-client #:*client*
           #:write #:prin1 #:print #:pprint #:princ
           #:write-to-string #:prin1-to-string #:princ-to-string))
