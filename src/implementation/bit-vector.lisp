(cl:in-package #:incless-implementation)

(defun print-bit-vector (client vec stream)
  (if (or *print-array* *print-readably*)
      (loop for bit across vec
            initially (write-string "#*" stream)
            do (write-char (if (zerop bit) #\0 #\1) stream))
      (incless:write-unreadable-object client vec t t)))
