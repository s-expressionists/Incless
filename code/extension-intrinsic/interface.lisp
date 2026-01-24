(in-package #:incless-extension-intrinsic)

(defclass intrinsic-client () ())

(defclass intrinsic-client-impl
    (intrinsic-client quaviver/schubfach:client)
  ())

(defvar *client* (make-instance 'intrinsic-client-impl))

(incless:define-interface *client* intrinsic-client t)
