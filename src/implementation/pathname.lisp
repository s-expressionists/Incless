(cl:in-package #:incless-implementation)

(defun print-pathname (client path stream)
  (when (or *print-escape* *print-readably*)
    (write-string "#P" stream))
  (incless:write-object client (namestring path) stream))
