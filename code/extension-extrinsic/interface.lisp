(in-package #:incless-extension-extrinsic)

(defclass extrinsic-client () ())

(defclass extrinsic-client-impl
    (extrinsic-client quaviver/schubfach:client)
  ())

(defvar *client* (make-instance 'extrinsic-client-impl))

(incless:define-interface :client-form *client* :client-class extrinsic-client)
