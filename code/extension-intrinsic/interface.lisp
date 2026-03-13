(in-package #:incless-extension-intrinsic)

(defclass client (incless-extension:client) ())

(defclass client-impl (client quaviver/schubfach:client) ())

(defvar *client* (make-instance 'client-impl))

(incless:define-interface *client* client t)
