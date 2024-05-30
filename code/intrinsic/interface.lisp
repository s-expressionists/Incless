(in-package #:incless-intrinsic)

(defclass intrinsic-client (quaviver/burger-dybvig:client-2) ())

(defvar *client* (make-instance 'intrinsic-client))

(incless:define-interface *client* intrinsic-client t)
