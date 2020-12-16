;;;; package.lisp

(defpackage #:incless
  (:use #:common-lisp)
  (:export #:print-object-using-client #:client
           #:standard-client #:*client*))

