(cl:in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (path pathname) stream)
  (when (or *print-escape* *print-readably*)
    (write-string "#P" stream))
  (write-object client (namestring path) stream))
