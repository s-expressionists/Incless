(in-package #:incless-native)

(defclass native-client () ())

(defmethod incless:write-object ((client native-client) object stream)
  (declare (ignorable client))
  #+abcl (system:output-object object stream)
  #+(or clasp ecl) (sys:write-object object stream)
  #+ccl (ccl::write-1 object stream)
  #+cmucl (kernel:output-object object stream)
  #+sbcl (sb-impl::output-object object stream))

(defmethod incless:print-object ((client native-client) object stream)
  (print-object object stream))

(defmethod incless:handle-circle ((client native-client) object stream function)
  (declare (ignorable client))
  #+abcl (if (and *print-circle* (null sys::*circularity-hash-table*))
             (let ((sys::*circularity-hash-table* (make-hash-table :test 'eq)))
               (setf (gethash object sys::*circularity-hash-table*) t)
               (funcall function object (make-broadcast-stream))
               (let ((sys::*circularity-counter* 0))
                 (when (eql 0 (gethash object sys::*circularity-hash-table*))
                   (setf (gethash object sys::*circularity-hash-table*)
                         (incf sys::*circularity-counter*))
                   (sys::print-label (gethash object sys::*circularity-hash-table*)
                                     stream))
                 (funcall function object stream)))
             (funcall function object stream))
  #+(or clasp ecl) (sys::write-object-with-circle object stream function)
  ;;; Poking around in CMUCL's internals wouldn't be needed if WITH-CIRCULARITY-DETECTION
  ;;; called the body function in the first pass versus calling OUTPUT-OBJECT.
  #+cmucl (cond ((not *print-circle*)
                 (funcall function object stream))
                (lisp::*circularity-hash-table*
                 (let ((marker (kernel:check-for-circularity object t :logical-block)))
                   (when (or (not marker)
                             (kernel:handle-circularity marker stream))
                     (funcall function object stream))))
                (t
                 (let ((lisp::*circularity-hash-table* (make-hash-table :test 'eq)))
                   (funcall function object (make-broadcast-stream))
                   (let ((lisp::*circularity-counter* 0))
                     (let ((marker (kernel:check-for-circularity object t
                                                                 :logical-block)))
                       (when marker
                         (kernel:handle-circularity marker stream)))
                     (funcall function object stream)))))
  #-(or abcl clasp cmucl ecl) (funcall function object stream))

(defmethod incless:write-unreadable-object
    ((client native-client) object stream type identity function)
  (declare (ignore client))
  (print-unreadable-object (object stream :type type :identity identity)
    (funcall function)))

(defmethod incless:circle-check ((client native-client) object stream)
  (declare (ignore client stream))
  #+abcl (and (system::check-for-circularity object) t)
  #+clasp (and *print-circle* object core::*circle-counter*
               (if (eq core::*circle-counter* t)
                   (plusp (core::search-print-circle object))
                   (gethash object core::*circle-stack*)))
  #+cmucl (and (kernel:check-for-circularity object) t)
  #+ecl (and *print-circle* object sys::*circle-counter*
               (if (eq sys::*circle-counter* t)
                   (plusp (sys::search-print-circle object))
                   (gethash object sys::*circle-stack*)))
  #+sbcl (and (sb-impl::check-for-circularity object) t))
