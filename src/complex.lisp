(in-package #:incless)

(defun print-complex (client obj stream)
  (write-string "#C(" stream)
  (write-object client (realpart obj) stream)
  (write-char #\  stream)
  (write-object client (imagpart obj) stream)
  (write-char #\) stream))
