(cl:in-package #:incless-implementation)

(defvar *current-depth* 0)

(defvar *circularity-hash-table* nil)

(defvar *circularity-counter* nil)

(defun uniquely-identified-by-print-p (x)
  (or (numberp x)
      (characterp x)
      (symbolp x)))

(defun handle-circle (client object stream function)
  (declare (ignore client))
  (flet ((body-fun ()
           (when (and *circularity-hash-table*
                      (not (uniquely-identified-by-print-p object)))
             (multiple-value-bind (current presentp)
                 (gethash object *circularity-hash-table*)
               (cond ((and *circularity-hash-table*
                           *circularity-counter*
                           (eq t current))
                      (setf (gethash object *circularity-hash-table*)
                            (incf *circularity-counter*))
                      (write-char #\# stream)
                      (print-object *circularity-counter* stream)
                      (write-char #\= stream))
                     ((and *circularity-hash-table*
                           *circularity-counter*
                           current)
                      (write-char #\# stream)
                      (print-object current stream)
                      (write-char #\# stream)
                      (return-from body-fun))
                     (*circularity-hash-table*
                      (setf (gethash object *circularity-hash-table*) presentp)))))
           (funcall function object stream)))
    (if (and *print-circle*
             (not *circularity-hash-table*))
        (let ((*circularity-hash-table* (make-hash-table :test #'eq))
              (*circularity-counter* nil))
          (body-fun)
          (setf *circularity-counter* 0)
          (body-fun))
        (body-fun))))

(defun circle-check (client object)
  (declare (ignore client))
  (and *print-circle*
       *circularity-hash-table*
       *circularity-counter*
       (not (uniquely-identified-by-print-p object))
       (gethash object *circularity-hash-table*)
       t))

(defun write-unreadable-object
    (client object stream type identity function)
  (cond (*print-readably*
         (error 'print-not-readable :object object))
        (t
         (write-string "#<" stream)
         (when type
           (let (*print-circle* *print-length* *print-level*)
             (incless:write-object client (type-of object) stream))
           (write-char #\space stream))
         (when function
           (funcall function))
         (when identity
           (when (or function (not type))
             (write-char #\space stream))
           (incless:write-identity client object stream))
         (write-char #\> stream)))
  nil)
