(in-package #:incless)

;;; this is probably a bad solution

(defgeneric parameter-override-list (client))

(defmethod parameter-override-list (client)
  nil)
