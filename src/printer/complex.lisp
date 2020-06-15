(in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (obj complex) stream)
  (write-string "#C(")
  (print-object-using-client client (realpart obj) stream)
  (write-char #\  stream)
  (print-object-using-client client (imagpart obj) stream)
  (write-char #\) stream))
