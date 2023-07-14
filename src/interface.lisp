(in-package #:incless)

(defvar *client* nil)

(defgeneric write-object (client object stream))

(defgeneric print-object (client object stream))

(defgeneric write-unreadable-object (client object stream type identity function))

(defgeneric write-identity (client object stream)
  #+(or ccl clasp sbcl)
  (:method (client object stream)
    (declare (ignorable client))
    (write-char #\@ stream)
    #+clasp
    (core:write-addr object stream)
    #+(or abcl ccl sbcl)
    (let ((*print-radix* t)
          (*print-base* 16))
      (incless:write-object client
                            #+abcl (system:identity-hash-code object)
                            #+ccl (ccl:%address-of object)
                            #+sbcl (sb-kernel:get-lisp-obj-address object)
                            stream))))

(defgeneric handle-circle (client object stream function)
  (:method (client object stream function)
    (declare (ignore client))
    (funcall function object stream)))

(defgeneric circle-check (client object stream)
  (:method (client object stream)
    (declare (ignore client object stream))
    nil))

(defgeneric circle-detection-p (client stream)
  (:method (client object)
    (declare (ignore client stream))
    nil))

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
