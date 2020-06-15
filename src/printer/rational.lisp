(in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (obj ratio) stream)
  (when *print-radix*
    (write-radix *print-base* stream))
  (write-sign obj stream)
  (write-integer-digits (numerator obj) stream)
  (write-string "/" stream)
  (write-integer-digits (denominator obj) stream))
