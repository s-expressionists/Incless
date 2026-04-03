(in-package #:incless)

(defun print-rational (client obj stream)
  (unless (circle-detection-p client stream)
    (when *print-radix*
      (case *print-base*
        (2
         (write-string "#b" stream))
        (8
         (write-string "#o" stream))
        (10
         (write-string "#10r" stream))
        (16
         (write-string "#x" stream))
        (otherwise
         (write-char #\# stream)
         (quaviver:write-digits 10 *print-base* stream)
         (write-char #\r stream))))
    (cond ((minusp (numerator obj))
           (write-char #\- stream)
           (quaviver:write-digits *print-base* (- (numerator obj)) stream))
          (t
           (quaviver:write-digits *print-base* (numerator obj) stream)))
    (write-string "/" stream)
    (quaviver:write-digits *print-base* (denominator obj) stream)))
