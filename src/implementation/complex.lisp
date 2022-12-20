(in-package #:incless-implementation)

(defun print-complex (client obj stream)
  (write-string "#C(" stream)
  (incless:write-object client (realpart obj) stream)
  (write-char #\  stream)
  (incless:write-object client (imagpart obj) stream)
  (write-char #\) stream))
