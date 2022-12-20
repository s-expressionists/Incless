(cl:in-package #:incless-implementation)

(defun print-bit-vector (client vec stream)
  (cond ((or *print-array* *print-readably*)
         (write-string "#*" stream)
         (loop :for bit :across vec
               :do (if (zerop bit)
                       (write-char #\0 stream)
                       (write-char #\1 stream))))
        (t
         (incless:write-unreadable-object client vec t t)))
  vec)
