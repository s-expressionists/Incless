(cl:in-package #:incless)

(defmethod print-object-using-client
    ((client standard-client) (object standard-object) stream)
  (print-unreadable-object (object stream :type t :identity t)
    nil))
