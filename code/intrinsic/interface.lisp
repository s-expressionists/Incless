(in-package #:incless-intrinsic)

(defclass intrinsic-client () ())

(defclass intrinsic-client-impl
    (intrinsic-client quaviver/shucbfach:client)
  ())

(defvar *client* (make-instance 'intrinsic-client-impl))

(incless:define-interface *client* intrinsic-client t)
