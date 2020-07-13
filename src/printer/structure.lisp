(in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (struct structure-object) stream)
  (when *print-readably*
    (error 'print-not-readable-unimplementable :object struct))
  (unreadably client struct stream))
