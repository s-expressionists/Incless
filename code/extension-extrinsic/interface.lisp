(in-package #:incless-extension-extrinsic)

(defclass client (incless-extension:client) ())

(defclass client-impl (client quaviver/schubfach:client) ())

(defvar *client* (make-instance 'client-impl))

(incless:define-interface :client-form *client* :client-class client)
