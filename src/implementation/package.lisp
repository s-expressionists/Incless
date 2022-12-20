;;;; package.lisp

(defpackage #:incless-implementation
  (:use #:common-lisp)
  (:export #:circle-check
           #:handle-circle
           #:print-array
           #:print-bit-vector
           #:print-character
           #:print-complex
           #:print-cons
           #:print-integer
           #:print-pathname
           #:print-random-state
           #:print-rational
           #:print-string
           #:print-structure
           #:print-symbol
           #:print-vector
           #:write-unreadable-object))
