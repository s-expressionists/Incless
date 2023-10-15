(in-package #:incless-intrinsic)

(defclass intrinsic-client () ())

(defvar *client* (make-instance 'intrinsic-client))

(incless:define-interface *client* intrinsic-client t)
