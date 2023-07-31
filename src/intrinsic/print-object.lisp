(in-package #:incless-intrinsic)

(defmethod print-object (object stream)
  (incless:write-unreadable-object *client* object stream t t nil)
  object)

(defmethod print-object ((object array) stream)
  (incless-implementation:print-array *client* object stream))

(defmethod print-object ((object bit-vector) stream)
  (incless-implementation:print-bit-vector *client* object stream))

(defmethod print-object ((object character) stream)
  (incless-implementation:print-character *client* object stream))

(defmethod print-object ((object complex) stream)
  (incless-implementation:print-complex *client* object stream))

(defmethod print-object ((object cons) stream)
  (incless-implementation:print-cons *client* object stream))

(defmethod print-object ((object integer) stream)
  (incless-implementation:print-integer *client* object *print-base* *print-radix* stream))

(defmethod print-object ((object float) stream)
  (incless-implementation:print-float *client* object stream))

(defmethod print-object ((object pathname) stream)
  (incless-implementation:print-pathname *client* object stream))

(defmethod print-object ((object random-state) stream)
  (incless-implementation:print-random-state *client* object stream))

(defmethod print-object ((object rational) stream)
  (incless-implementation:print-rational *client* object stream))

(defmethod print-object ((object string) stream)
  (incless-implementation:print-string *client* object stream))

(defmethod print-object ((object symbol) stream)
  (incless-implementation:print-symbol *client* object stream))

(defmethod print-object ((object vector) stream)
  (incless-implementation:print-vector *client* object stream))
