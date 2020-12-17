(cl:in-package #:incless)

(defun unreadably (client obj stream)
  (write-string "#<" stream)
  (print-object-using-client client (type-of obj) stream)
  (write-char #\>))

;;; FIXME figure out how to print an identity
(defmacro print-unreadable-object
    ((object stream &key type identity) &body body)
  (let ((object-var (gensym))
        (stream-var (gensym))
        (type-var (gensym))
        (identity-var (gensym)))
    `(let ((,object-var ,object)
           (,stream-var ,stream)
           (,type-var ,type)
           (,identity-var ,identity))
       (if *print-readably*
           (error 'print-not-readable :object ,object-var)
           (progn
             (write-string  "#<" ,stream-var)
             (when ,type-var
               (write-string (symbol-name (class-name (class-of ,object-var))) ,stream-var))
             (when ,identity-var
               (write-string  " ID" ,stream-var))
             ,@body
             (write-string ">" ,stream-var))))))

;; (defmacro def-identical-printers ((var (&rest types)) &body body)
;;   `(progn
;;      ,@(loop :for type :in types
;;              :collect `(defmethod print-object-using-client ((client standard-client)
;;                                                              (,var ,type) stream)
;;                          ,@body))))
