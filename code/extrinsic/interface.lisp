(in-package #:incless-extrinsic)

(defclass extrinsic-client () ())

(defclass extrinsic-client-impl
    (extrinsic-client quaviver/schubfach:client)
  ())

(defvar *client* (make-instance 'extrinsic-client-impl))

(incless:define-interface *client* extrinsic-client)
