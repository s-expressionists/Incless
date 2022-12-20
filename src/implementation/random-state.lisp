(in-package #:incless-implementation)

#+(or)(defmethod print-object ((state random-state) stream)
  ;; CL requires a readable representation of RANDOM-STATE, however, we cannot do that.
  (incless:write-unreadable-object *client* state t t)
  state)
