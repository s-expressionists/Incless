(in-package #:incless)

(defun print-rational (client obj stream)
  (unless (circle-detection-p client stream)
    (when *print-radix*
      (write-radix *print-base* stream))
    (cond ((minusp (numerator obj))
           (write-char #\- stream)
           (quaviver:write-digits *print-base* (- (numerator obj)) stream))
          (t
           (quaviver:write-digits *print-base* (numerator obj) stream)))
    (write-string "/" stream)
    (quaviver:write-digits *print-base* (denominator obj) stream)))
