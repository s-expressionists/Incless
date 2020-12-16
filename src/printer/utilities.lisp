(cl:in-package #:incless)

(defun unreadably (client obj stream)
  (write-string "#<" stream)
  (print-object-using-client client (type-of obj) stream)
  (write-char #\>))

;; (defmacro def-identical-printers ((var (&rest types)) &body body)
;;   `(progn
;;      ,@(loop :for type :in types
;;              :collect `(defmethod print-object-using-client ((client standard-client)
;;                                                              (,var ,type) stream)
;;                          ,@body))))
