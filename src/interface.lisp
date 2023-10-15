(in-package #:incless)

(defvar *client* nil)

(defgeneric write-object (client object stream))

(defgeneric print-object (client object stream))

(defgeneric write-unreadable-object (client object stream type identity function))

(defgeneric write-identity (client object stream)
  #+(or abcl ccl clasp cmucl ecl sbcl)
  (:method (client object stream)
    (declare (ignorable client))
    (write-char #\@ stream)
    #+clasp
    (core:write-addr object stream)
    #+(or abcl ccl cmucl ecl sbcl)
    (let ((*print-radix* t)
          (*print-base* 16))
      (incless:write-object client
                            #+abcl (system:identity-hash-code object)
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

(defgeneric printer-readtable (client)
  (:method (client)
    (declare (ignore client))
    (if *print-readably*
        #+sbcl sb-impl::*standard-readtable*
        #-sbcl (with-standard-io-syntax *readtable*)
        *readtable*)))

(defgeneric client-form (client))

(defmacro define-interface (client-var client-class &optional intrinsic)
  (let* ((pkg (if intrinsic (find-package "COMMON-LISP") *package*))
         (print-object-name (intern "PRINT-OBJECT" pkg)))
    `(progn
       (defmethod client-form ((client ,client-class))
         ',client-var)

       (defgeneric ,print-object-name (object stream))

       (defun ,(intern "WRITE" pkg)
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
         (write-object ,client-var object stream)
         object)

       (defun ,(intern "WRITE-TO-STRING" pkg)
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
           (write-object ,client-var object stream)))

       (defun ,(intern "PRIN1" pkg) (object &optional (stream *standard-output*)
                                     &aux (*print-escape* t))
         (write-object ,client-var object stream)
         object)

       (defun ,(intern "PRINC" pkg) (object &optional (stream *standard-output*)
                                     &aux (*print-escape* nil)
                                       (*print-readably* nil))
         (write-object ,client-var object stream)
         object)

       (defun ,(intern "PRINT" pkg) (object &optional (stream *standard-output*)
                                     &aux (*print-escape* t))
         (write-char #\Newline stream)
         (write-object ,client-var object stream)
         (write-char #\Space stream)
         object)

       (defun ,(intern "PPRINT" pkg) (object &optional (stream *standard-output*)
                                      &aux (*print-escape* t)
                                        (*print-pretty* t))
         (write-char #\Newline stream)
         (write-object ,client-var object stream)
         (values))

       (defun ,(intern "PRIN1-TO-STRING" pkg) (object
                                               &aux (*print-escape* t))
         (with-output-to-string (stream)
           (write-object ,client-var object stream)))

       (defun ,(intern "PRINC-TO-STRING" pkg) (object
                                               &aux (*print-escape* nil)
                                                 (*print-readably* nil))
         (with-output-to-string (stream)
           (write-object ,client-var object stream)))

       (defmacro ,(intern "PRINT-UNREADABLE-OBJECT" pkg)
           ((object stream &key type identity) &body body)
         (list 'write-unreadable-object
               ,client-var object stream type identity
               (list* 'lambda '() body)))

       (defmethod print-object ((client ,client-class) object stream)
         (declare (ignore client))
         (,print-object-name object stream))

       (defmethod write-object ((client ,client-class) object stream)
         (handle-circle client object stream #',print-object-name)
         object)

       (defmethod ,print-object-name (object stream)
         (write-unreadable-object ,client-var object stream t t nil)
         object)

       (defmethod ,print-object-name ((object array) stream)
         (print-array ,client-var object stream))

       (defmethod ,print-object-name ((object bit-vector) stream)
         (print-bit-vector ,client-var object stream))

       (defmethod ,print-object-name ((object character) stream)
         (print-character ,client-var object stream))

       (defmethod ,print-object-name ((object complex) stream)
         (print-complex ,client-var object stream))

       (defmethod ,print-object-name ((object cons) stream)
         (print-cons ,client-var object stream))

       (defmethod ,print-object-name ((object integer) stream)
         (print-integer ,client-var object *print-base* *print-radix* stream))

       (defmethod ,print-object-name ((object float) stream)
         (print-float ,client-var object stream))

       (defmethod ,print-object-name ((object pathname) stream)
         (print-pathname ,client-var object stream))

       (defmethod ,print-object-name ((object random-state) stream)
         (print-random-state ,client-var object stream))

       (defmethod ,print-object-name ((object rational) stream)
         (print-rational ,client-var object stream))

       (defmethod ,print-object-name ((object string) stream)
         (print-string ,client-var object stream))

       (defmethod ,print-object-name ((object structure-object) stream)
         (print-structure ,client-var object stream))

       (defmethod ,print-object-name ((object symbol) stream)
         (print-symbol ,client-var object stream))

       (defmethod ,print-object-name ((object vector) stream)
         (print-vector ,client-var object stream)))))
