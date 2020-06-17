(cl:in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (vec bit-vector) stream)
  (cond ((or *print-array* *print-readably*)
         (write-string "#*" stream)
         (loop :for bit :across vec
               :do (if (zerop bit)
                       (write-char #\0 stream)
                       (write-char #\1 stream))))
        (t (write-string "#<BIT-VECTOR>" stream)))
  vec)
