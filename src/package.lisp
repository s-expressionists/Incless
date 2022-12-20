(defpackage #:incless
  (:use #:cl)
  (:shadow #:print-object)
  (:export #:circle-check
           #:class-slot-names
           #:handle-circle
           #:print-object
           #:write-identity
           #:write-object
           #:write-unreadable-object))
