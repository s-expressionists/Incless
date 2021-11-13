(in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (obj complex) stream)
  (write-string "#C(" stream)
  (write-object client (realpart obj) stream)
  (write-char #\  stream)
  (write-object client (imagpart obj) stream)
  (write-char #\) stream))
