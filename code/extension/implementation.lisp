(in-package #:incless-extension)

(defclass client (incless:client) ())

(defmethod trinsic:features-list nconc ((client client))
  (list :print/incless-extension))
