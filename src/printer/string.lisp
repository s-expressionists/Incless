(in-package #:incless)

(defmethod print-object-using-client
    ((client standard-client) (object string) stream)
  (if (or *print-escape* *print-readably*)
      (progn (write-char #\" stream)
             (loop :for x :across object
                   :do (when (or (char= x #\") (char= x #\\))
                         (write-char #\\ stream))
                       (write-char x stream))
             (write-char #\" stream))
      (write-string obj stream)))
