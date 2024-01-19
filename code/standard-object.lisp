(cl:in-package #:incless)

#+(or)(defmethod print-standard-object (client object stream)
  (write-unreadable-object *client* object t t)
  object)
