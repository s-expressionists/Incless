(cl:in-package #:incless)

;;; placeholder implementation needed by other printers

(defmethod print-object-using-client ((client standard-client) (sym symbol) stream)
  (write-string (symbol-name sym)))
