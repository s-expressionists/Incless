(in-package #:incless-extrinsic)

(defclass extrinsic-client () ())

(defvar *client* (make-instance 'extrinsic-client))

(incless:define-interface *client* extrinsic-client)
