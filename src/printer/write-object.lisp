(cl:in-package #:incless)

(defvar *circularity-hash-table* nil)

(defvar *circularity-counter* nil)

(defun uniquely-identified-by-print-p (x)
  (or (numberp x)
      (characterp x)
      (symbolp x)))

(defmacro with-print-circle ((stream-var object-var) &body body)
  (let ((body-var (gensym)))
    `(flet ((,body-var (,stream-var)
              (when (and *circularity-hash-table*
                         (not (uniquely-identified-by-print-p ,object-var)))
                (multiple-value-bind (current presentp)
                    (gethash ,object-var *circularity-hash-table*)
                  (cond ((and *circularity-hash-table*
                              *circularity-counter*
                              (eq t current))
                         (setf (gethash ,object-var *circularity-hash-table*)
                               (incf *circularity-counter*))
                         (write-char #\# ,stream-var)
                         (print-object *circularity-counter* ,stream-var)
                         (write-char #\= ,stream-var))
                        ((and *circularity-hash-table*
                              *circularity-counter*
                              current)
                         (write-char #\# ,stream-var)
                         (print-object current ,stream-var)
                         (write-char #\# ,stream-var)
                         (return-from ,body-var))
                        (*circularity-hash-table*
                         (setf (gethash ,object-var *circularity-hash-table*) presentp)))))
              ,@body))
       (if (and *print-circle*
                (not *circularity-hash-table*))
           (let ((*circularity-hash-table* (make-hash-table :test #'eq))
                 (*circularity-counter* nil))
             (,body-var (make-broadcast-stream))
             (setf *circularity-counter* 0)
             (,body-var ,stream-var))
           (,body-var ,stream-var)))))

(defmethod write-object :around (client object stream)
  (let ((*client* client))
    (with-print-circle (stream object)
      (call-next-method client object stream))))

(defmethod write-object ((client standard-client) object stream)
  (declare (ignore client))
  (print-object object stream)
  object)
