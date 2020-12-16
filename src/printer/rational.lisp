(in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (obj ratio) stream)
  (when *print-radix*
    (write-radix *print-base* stream))
  (write-sign obj stream)
  (write-integer-digits (abs (numerator obj)) *print-base* stream)
  (write-string "/" stream)
  (write-integer-digits (denominator obj) *print-base* stream))
