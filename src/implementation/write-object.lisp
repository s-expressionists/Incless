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
  (if (or (not *print-circle*)
          (uniquely-identified-by-print-p object))
      (funcall function object stream)
      (flet ((circle-func (stream)
               (multiple-value-bind (current presentp)
                   (gethash object *circularity-hash-table*)
                 (cond ((not *circularity-counter*)
                        (setf (gethash object *circularity-hash-table*) presentp)
                        (when presentp (return-from circle-func)))
                       ((eq t current)
                        (setf (gethash object *circularity-hash-table*)
                              (incf *circularity-counter*))
                        (write-char #\# stream)
                        (print-object *circularity-counter* stream)
                        (write-char #\= stream))
                       (current
                        (write-char #\# stream)
                        (print-object current stream)
                        (write-char #\# stream)
                        (return-from circle-func))))
               (funcall function object stream)))
        (if *circularity-hash-table*
            (circle-func stream)
            (let ((*circularity-hash-table* (make-hash-table :test #'eq))
                  (*circularity-counter* nil))
              (circle-func (make-broadcast-stream))
              (setf *circularity-counter* 0)
              (circle-func stream))))))

(defun circle-check (client object)
  (declare (ignore client))
  (if *circularity-counter*
      (and *print-circle*
           *circularity-hash-table*
           (not (uniquely-identified-by-print-p object))
           (gethash object *circularity-hash-table*)
           t)
      (multiple-value-bind (current presentp)
          (gethash object *circularity-hash-table*)
        (declare (ignore current))
        (setf (gethash object *circularity-hash-table*) presentp))))

(defun write-unreadable-object
    (client object stream &optional type identity function)
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
