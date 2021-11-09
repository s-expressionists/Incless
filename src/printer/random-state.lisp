(in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (state random-state) stream)
  ;; CL requires a readable representation of RANDOM-STATE, however, we cannot do that.
  (when *print-readably*
    (error 'print-not-readable-unimplementable :object state))
  (unreadably client state stream))
