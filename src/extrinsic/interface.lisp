(in-package #:incless-extrinsic)

(defclass extrinsic-client () ())

(defvar *client* (make-instance 'extrinsic-client))

(defmethod incless:client-form ((client extrinsic-client))
  '*client*)

(defgeneric print-object (object stream))

(defun write
    (object
     &key (stream *standard-output*)
          ((:array *print-array*) *print-array*)
          ((:base *print-base*) *print-base*)
          ((:case *print-case*) *print-case*)
          ((:circle *print-circle*) *print-circle*)
          ((:escape *print-escape*) *print-escape*)
          ((:gensym *print-gensym*) *print-gensym*)
          ((:length *print-length*) *print-length*)
          ((:level *print-level*) *print-level*)
          ((:lines *print-lines*) *print-lines*)
          ((:miser-width *print-miser-width*) *print-miser-width*)
          ((:pprint-dispatch *print-pprint-dispatch*) *print-pprint-dispatch*)
          ((:pretty *print-pretty*) *print-pretty*)
          ((:radix *print-radix*) *print-radix*)
          ((:readably *print-readably*) *print-readably*)
          ((:right-margin *print-right-margin*) *print-right-margin*))
  (incless:write-object *client* object stream)
  object)

(defun write-to-string
    (object
     &key ((:array *print-array*) *print-array*)
          ((:base *print-base*) *print-base*)
          ((:case *print-case*) *print-case*)
          ((:circle *print-circle*) *print-circle*)
          ((:escape *print-escape*) *print-escape*)
          ((:gensym *print-gensym*) *print-gensym*)
          ((:length *print-length*) *print-length*)
          ((:level *print-level*) *print-level*)
          ((:lines *print-lines*) *print-lines*)
          ((:miser-width *print-miser-width*) *print-miser-width*)
          ((:pprint-dispatch *print-pprint-dispatch*) *print-pprint-dispatch*)
          ((:pretty *print-pretty*) *print-pretty*)
          ((:radix *print-radix*) *print-radix*)
          ((:readably *print-readably*) *print-readably*)
          ((:right-margin *print-right-margin*) *print-right-margin*))
  (with-output-to-string (stream)
    (incless:write-object *client* object stream)))

(defun prin1 (object &optional (stream *standard-output*)
              &aux (*print-escape* t))
  (incless:write-object *client* object stream)
  object)

(defun princ (object &optional (stream *standard-output*)
              &aux (*print-escape* nil)
                   (*print-readably* nil))
  (incless:write-object *client* object stream)
  object)

(defun print (object &optional (stream *standard-output*))
  (write-char #\Newline stream)
  (prin1 object stream)
  (write-char #\Space stream)
  object)

(defun pprint (object &optional (stream *standard-output*)
               &aux (*print-pretty* t))
  (write-char #\Newline stream)
  (prin1 object stream)
  (values))

(defun prin1-to-string (object)
  (with-output-to-string (stream)
    (prin1 object stream)))

(defun princ-to-string (object)
  (with-output-to-string (stream)
    (princ object stream)))

(defmacro print-unreadable-object
    ((object stream &key type identity) &body body)
  `(incless:write-unreadable-object *client* ,object ,stream ,type ,identity
                                    (lambda () ,@body)))

(defmethod incless:handle-circle ((client extrinsic-client) object stream function)
  (incless-implementation:handle-circle client object stream function))

(defmethod incless:print-object ((client extrinsic-client) object stream)
  (declare (ignore client))
  (print-object object stream))

(defmethod incless:write-object ((client extrinsic-client) object stream)
  (incless:handle-circle client object stream #'print-object)
  object)

(defmethod incless:write-unreadable-object ((client extrinsic-client) object stream type identity function)
  (incless-implementation:write-unreadable-object client object stream type identity function))

(defmethod incless:circle-check ((client extrinsic-client) object stream)
  (incless-implementation:circle-check client object stream))

(defmethod incless:circle-detection-p ((client extrinsic-client) stream)
  (incless-implementation:circle-detection-p client stream))
