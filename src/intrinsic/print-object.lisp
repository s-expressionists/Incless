(in-package #:incless-intrinsic)

(defmethod print-object (object stream)
  (incless:write-unreadable-object *client* object stream t t nil)
  object)

(defmethod print-object ((object array) stream)
  (incless:print-array *client* object stream))

(defmethod print-object ((object bit-vector) stream)
  (incless:print-bit-vector *client* object stream))

(defmethod print-object ((object character) stream)
  (incless:print-character *client* object stream))

(defmethod print-object ((object complex) stream)
  (incless:print-complex *client* object stream))

(defmethod print-object ((object cons) stream)
  (incless:print-cons *client* object stream))

(defmethod print-object ((object integer) stream)
  (incless:print-integer *client* object *print-base* *print-radix* stream))

(defmethod print-object ((object float) stream)
  (incless:print-float *client* object stream))

(defmethod print-object ((object pathname) stream)
  (incless:print-pathname *client* object stream))

(defmethod print-object ((object random-state) stream)
  (incless:print-random-state *client* object stream))

(defmethod print-object ((object rational) stream)
  (incless:print-rational *client* object stream))

(defmethod print-object ((object string) stream)
  (incless:print-string *client* object stream))

(defmethod print-object ((object symbol) stream)
  (incless:print-symbol *client* object stream))

(defmethod print-object ((object vector) stream)
  (incless:print-vector *client* object stream))
