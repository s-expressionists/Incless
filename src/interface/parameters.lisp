(in-package #:incless)

;;; this is probably a bad solution

(defgeneric parameter-override-list (client)
  (:method-combination list))

(defmethod parameter-override-list list (client)
  nil)
