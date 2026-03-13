(in-package #:incless-extrinsic)

(defclass client (incless:client) ())

(defclass client-impl (client quaviver/schubfach:client) ())

(defvar *client* (make-instance 'client-impl))

(incless:define-interface :client-form *client* :client-class client)
