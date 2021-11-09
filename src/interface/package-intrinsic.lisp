;;;; package.lisp

(defpackage #:incless
  (:use #:common-lisp)
  (:export #:print-object-using-client #:client #:write-object
           #:with-print-circle #:standard-client #:*client*))

