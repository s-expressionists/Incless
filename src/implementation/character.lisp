(in-package #:incless-implementation)

(defun print-character (client obj stream)
  (declare (ignore client))
  (cond ((circle-detection-p client stream))
        ((or *print-escape* *print-readably*)
         (let ((name (char-name obj)))
           (write-string "#\\" stream)
           (if (and name
                    (or (not (and (standard-char-p obj)
                                  (graphic-char-p obj)))
                        *print-readably*))
               (loop for x across name
                     when (or (char= x #\") (char= x #\\))
                       do (write-char #\\ stream)
                     do (write-char x stream))
               (write-char obj stream))))
        (t
         (write-char obj stream))))
