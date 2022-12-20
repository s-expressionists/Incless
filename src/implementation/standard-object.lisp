(cl:in-package #:incless-implementation)

#+(or)(defmethod print-standard-object (client object stream)
  (incless:write-unreadable-object *client* object t t)
  object)
