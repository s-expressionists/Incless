(in-package #:incless)

(defun print-integer (client integer base radix stream)
  ;; Determine whether a radix prefix should be printed, and if so,
  ;; which one.
  (unless (circle-detection-p client stream)
    (when radix
      (case base
        (2
         (write-string "#b" stream))
        (8
         (write-string "#o" stream))
        (10
         (write-string "" stream))
        (16
         (write-string "#x" stream))
        (otherwise
         (write-char #\# stream)
         (quaviver:write-digits 10 base stream)
         (write-char #\r stream))))
    (cond ((minusp integer)
           (write-char #\- stream)
           (quaviver:write-digits base (- integer) stream))
          (t
           (quaviver:write-digits base integer stream)))
    ;; Determine whether a trailing dot should be printed.
    (when (and radix (= base 10))
      (write-char #\. stream))))
