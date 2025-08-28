(in-package #:incless)

(declaim (inline coerce-output-stream-designator))

(defgeneric write-object (client object stream))

(defgeneric print-object (client object stream))

(defgeneric write-unreadable-object (client object stream type identity function))

(defgeneric write-identity (client object stream)
  #+(or abcl allegro ccl clasp cmucl ecl sbcl)
  (:method (client object stream)
    (declare (ignorable client))
    (write-char #\@ stream)
    #+clasp
    (core:write-addr object stream)
    #+(or abcl allegro ccl cmucl ecl sbcl)
    (let ((*print-radix* t)
          (*print-base* 16))
      (incless:write-object client
                            #+abcl (system:identity-hash-code object)
                            #+allegro (excl:lispval-to-address object)
                            #+ccl (ccl:%address-of object)
                            #+cmucl (lisp::get-lisp-obj-address object)
                            #+ecl (si:pointer object)
                            #+sbcl (sb-kernel:get-lisp-obj-address object)
                            stream))))

(defgeneric handle-circle (client object stream function))

(defgeneric circle-check (client object stream))

(defgeneric circle-detection-p (client stream))

(defgeneric class-slot-names (client class)
  (:method (client class)
    (declare (ignore client))
    #+abcl
    (mapcar #'mop:slot-definition-name
            (mop:class-slots class))
    #+ccl
    (mapcar #'ccl:slot-definition-name
            (ccl:class-slots class))
    #+(or clasp clisp ecl lispworks scl)
    (mapcar #'clos:slot-definition-name
            (clos:class-slots class))
    #+cmucl
    (mapcar #'clos-mop:slot-definition-name
            (clos-mop:class-slots class))
    #+mezzano
    (mapcar #'mezzano.clos:slot-definition-name
            (mezzano.clos:class-slots class))
    #+sicl
    (mapcar #'sicl-clos:slot-definition-name
            (sicl-clos:class-slots class))
    #+sbcl
    (mapcar #'sb-mop:slot-definition-name
            (sb-mop:class-slots class)))
  #+abcl
  (:method (client (class structure-class))
    (declare (ignore client))
    (mapcar (lambda (slot)
              (system::dsd-name slot))
            (mop:class-slots class))))

(trinsic:make-define-interface (:client-form client-form :client-class client-class)
    ((print-object-sym cl:print-object)
     (write-sym cl:write)
     (write-to-string-sym cl:write-to-string)
     (prin1-sym cl:prin1)
     (princ-sym cl:princ)
     (print-sym cl:print)
     (pprint-sym cl:pprint)
     (prin1-to-string-sym cl:prin1-to-string)
     (princ-to-string-sym cl:princ-to-string)
     (print-unreadable-object-sym cl:print-unreadable-object))
  `((defgeneric ,print-object-sym (object stream)
      (:method (object stream)
        (write-unreadable-object ,client-form object stream t t nil)
        object)
      (:method ((object array) stream)
        (print-array ,client-form object stream))
      (:method ((object bit-vector) stream)
        (print-bit-vector ,client-form object stream))
      (:method ((object character) stream)
        (print-character ,client-form object stream))
      (:method ((object complex) stream)
        (print-complex ,client-form object stream))
      (:method ((object cons) stream)
        (print-cons ,client-form object stream))
      (:method ((object integer) stream)
        (print-integer ,client-form object *print-base* *print-radix* stream))
      (:method ((object float) stream)
        (print-float ,client-form object stream))
      (:method ((object pathname) stream)
        (print-pathname ,client-form object stream))
      (:method ((object random-state) stream)
        (print-random-state ,client-form object stream))
      (:method ((object rational) stream)
        (print-rational ,client-form object stream))
      (:method ((object string) stream)
        (print-string ,client-form object stream))
      (:method ((object structure-object) stream)
        (print-structure ,client-form object stream))
      (:method ((object symbol) stream)
        (print-symbol ,client-form object stream))
      (:method ((object vector) stream)
        (print-vector ,client-form object stream)))

    (defun ,write-sym
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
      (write-object ,client-form object stream)
      object)

    (defun ,write-to-string-sym
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
        (write-object ,client-form object stream)))

    (defun ,prin1-sym (object &optional (stream *standard-output*)
                       &aux (*print-escape* t))
      (write-object ,client-form object stream)
      object)

    (defun ,princ-sym (object &optional (stream *standard-output*)
                       &aux (*print-escape* nil)
                            (*print-readably* nil))
      (write-object ,client-form object stream)
      object)

    (defun ,print-sym (object &optional (stream *standard-output*)
                       &aux (*print-escape* t))
      (write-char #\Newline stream)
      (write-object ,client-form object stream)
      (write-char #\Space stream)
      object)

    (defun ,pprint-sym (object &optional (stream *standard-output*)
                        &aux (*print-escape* t)
                             (*print-pretty* t))
      (write-char #\Newline stream)
      (write-object ,client-form object stream)
      (values))

    (defun ,prin1-to-string-sym (object
                                 &aux (*print-escape* t))
      (with-output-to-string (stream)
        (write-object ,client-form object stream)))

    (defun ,princ-to-string-sym (object
                                 &aux (*print-escape* nil)
                                      (*print-readably* nil))
      (with-output-to-string (stream)
        (write-object ,client-form object stream)))

    (defmacro ,print-unreadable-object-sym
        ((object stream &key type identity) &body body)
      (list 'write-unreadable-object
            ,client-form object stream type identity
            (list* 'lambda '() body)))

    (defmethod print-object ((client ,client-class) object stream)
      (declare (ignore client))
      (,print-object-sym object stream))

    (defmethod write-object ((client ,client-class) object stream)
      (handle-circle client object stream #',print-object-sym)
      object)))
