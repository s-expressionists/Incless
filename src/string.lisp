(in-package #:incless)

(defun print-string (client object stream)
  (declare (ignore client))
  (cond ((circle-detection-p client stream))
        ((or *print-escape* *print-readably*)
         (loop for x across object
               initially (write-char #\" stream)
               finally (write-char #\" stream)
               when (or (char= x #\") (char= x #\\))
                 do (write-char #\\ stream)
               do (write-char x stream)))
        (t
         (write-string object stream))))
