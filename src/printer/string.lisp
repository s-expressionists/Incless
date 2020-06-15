(in-package #:incless)

(defun escape-string (string)
  (with-output-to-string (stream)
    (write-char #\" stream)
    (loop :for x :across string
          :do (when (or (char= x #\") (char= x #\\))
                (write-char #\\ stream))
              (write-char x stream))
    (write-char #\" stream)))

(defmethod print-object-using-client ((client standard-client) (obj string) stream)
  (if (or *print-escape* *print-readably*)
      (write-string (escape-string obj) stream)
      (write-string obj stream)))
