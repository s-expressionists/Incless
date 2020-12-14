(in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (obj character) stream)
  (if (or *print-escape* *print-readably*)
      (progn (write-string "#\\")
             (if (and (standard-char-p obj) (not (or (char= obj #\Space)
                                                     (char= obj #\Newline))))
                 (write-char obj stream)
                 (write-string (char-name obj) stream)))
      (write-char obj stream)))