(in-package #:incless-intrinsic)

(defclass client (incless:client) ())

(defclass client-impl (client quaviver/schubfach:client) ())

(defvar *client* (make-instance 'client-impl))

(incless:define-interface *client* client t)
