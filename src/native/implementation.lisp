(in-package #:incless-native)

(defclass native-client () ())

(defmethod incless:write-object ((client native-client) object stream)
  (declare (ignorable client))
  #+abcl (system:output-object object stream)
  #+(or clasp ecl) (sys:write-object object stream)
  #+sbcl (sb-impl::output-object object stream))

(defmethod incless:print-object ((client native-client) object stream)
  (print-object object stream))

(defmethod incless:handle-circle ((client native-client) object stream function)
  (declare (ignorable client))
  #+(or clasp ecl) (sys::write-object-with-circle object stream function)
  #-(or clasp ecl) (funcall function object stream))

(defmethod incless:write-unreadable-object
    ((client native-client) object stream type identity function)
  (declare (ignore client))
  (print-unreadable-object (object stream :type type :identity identity)
    (funcall function object stream)))

(defmethod incless:circle-check ((client native-client) object)
  (declare (ignore client))
  #+clasp (and *print-circle* object core::*circle-counter*
               (if (eq core::*circle-counter* t)
                   (plusp (core::search-print-circle object))
                   (gethash object core::*circle-stack*)))
  #+sbcl (and (sb-impl::check-for-circularity object) t))
