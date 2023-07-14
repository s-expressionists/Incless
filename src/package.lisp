(defpackage #:incless
  (:use #:cl)
  (:shadow #:print-object)
  (:export #:circle-check
           #:class-slot-names
           #:client-form
           #:handle-circle
           #:circle-detection-p
           #:print-object
           #:printer-readtable
           #:write-identity
           #:write-object
           #:write-unreadable-object))
