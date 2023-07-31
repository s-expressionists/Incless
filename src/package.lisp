;;;; package.lisp

(defpackage #:incless
  (:shadow #:print-object)
  (:use #:common-lisp)
  (:export #:burger-dybvig-2
           #:circle-check
           #:circle-detection-p
           #:class-slot-names
           #:client-form
           #:decimal
           #:decimal-digits
           #:decimal-position
           #:handle-circle
           #:print-array
           #:print-bit-vector
           #:print-character
           #:print-complex
           #:print-cons
           #:print-decimal
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
           #:round-decimal
           #:write-identity
           #:write-object
           #:write-unreadable-object))
