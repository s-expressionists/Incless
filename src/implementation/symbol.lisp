(cl:in-package #:incless-implementation)

;;; placeholder implementation needed by other printers

(defun print-symbol (client sym stream)
  (declare (ignore client))
  (let ((package (symbol-package sym)))
    (cond ((null package)
           (write-string "#:" stream))
          ((eq package (load-time-value (find-package "KEYWORD")))
           (write-string ":" stream))
          ((and (not (eq package *package*))
                (not (eq sym (find-symbol (symbol-name sym) *package*))))
           (write-string (package-name package) stream)
           (write-string ":" stream)))
    (write-string (symbol-name sym) stream)))
