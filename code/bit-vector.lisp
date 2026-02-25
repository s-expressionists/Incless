(cl:in-package #:incless)

(defun print-bit-vector (client vec stream)
  (cond ((circle-detection-p client stream))
        ((or *print-array* *print-readably*)
         (loop for bit across vec
               initially (write-string "#*" stream)
               do (write-char (if (zerop bit) #\0 #\1) stream)))
        (t
         (write-unreadable-object client vec stream t t nil))))
