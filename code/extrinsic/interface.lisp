(in-package #:incless-extrinsic)

(defclass extrinsic-client (quaviver/burger-dybvig:client-2) ())

(defvar *client* (make-instance 'extrinsic-client))

(incless:define-interface *client* extrinsic-client)
