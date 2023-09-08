;;;; package.lisp

(defpackage #:incless
  (:shadow #:print-object)
  (:use #:common-lisp)
  (:export #:*digit-chars*
           #:burger-dybvig-2
           #:circle-check
           #:circle-detection-p
           #:class-slot-names
           #:client-form
           #:handle-circle
           #:print-array
           #:print-bit-vector
           #:print-character
           #:print-complex
           #:print-cons
           #:print-float
           #:print-integer
           #:print-object
           #:print-pathname
           #:print-random-state
           #:print-rational
           #:print-string
           #:print-structure
           #:print-symbol
           #:print-vector
           #:printer-readtable
           #:write-identity
           #:write-object
           #:write-unreadable-object))
