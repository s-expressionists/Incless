(cl:in-package #:incless)

;;; placeholder implementation needed by other printers

(defmethod print-object-using-client ((client standard-client) (sym symbol) stream)
  (let ((package (symbol-package sym)))
    (cond ((null package)
           (write-string "#:" stream))
          ((eq package (find-package "KEYWORD")) ; seems inefficient
           (write-string ":" stream))
          ((not (eq package *package*))
           (write-string (package-name package) stream)
           (write-string ":" stream)))
    (write-string (symbol-name sym) stream)))
