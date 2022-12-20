(in-package #:incless-implementation)

(defun print-string (client object stream)
  (declare (ignore client))
  (if (or *print-escape* *print-readably*)
      (progn (write-char #\" stream)
             (loop :for x :across object
                   :do (when (or (char= x #\") (char= x #\\))
                         (write-char #\\ stream))
                       (write-char x stream))
             (write-char #\" stream))
      (write-string object stream)))
