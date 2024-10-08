(cl:in-package #:incless)

(defvar *current-depth* 0)

(defvar *circularity-hash-table* nil)

(defvar *circularity-counter* nil)

(defun uniquely-identified-by-print-p (x)
  (or (numberp x)
      (characterp x)
      (and (symbolp x)
           (symbol-package x)
           t)))

(defmethod handle-circle (client object stream function)
  (if (or (not *print-circle*)
          (uniquely-identified-by-print-p object))
      (funcall function object stream)
      (flet ((walk (stream)
               (multiple-value-bind (marker present)
                   (gethash object *circularity-hash-table*)
                 (unless marker
                   (setf (gethash object *circularity-hash-table*) present))
                 (unless present
                   (funcall function object stream))))
             (perform (&aux (marker (gethash object *circularity-hash-table*)))
               (case marker
                 ((t)
                  (setf (gethash object *circularity-hash-table*)
                        (incf *circularity-counter*))
                  (write-char #\# stream)
                  (print-integer client *circularity-counter* 10 nil stream)
                  (write-char #\= stream)
                  (funcall function object stream))
                 ((nil)
                  (funcall function object stream))
                 (otherwise
                  (write-char #\# stream)
                  (print-integer client marker 10 nil stream)
                  (write-char #\# stream)))))
        (cond ((not *circularity-hash-table*)
               (let ((*circularity-hash-table* (make-hash-table :test #'eq))
                     (*circularity-counter* nil))
                 (walk (make-broadcast-stream))
                 (setf *circularity-counter* 0)
                 (perform)))
              (*circularity-counter*
               (perform))
              (t
               (walk stream))))))

(defmethod circle-check (client object stream)
  (declare (ignore client stream))
  (cond (*circularity-counter*
         (and *print-circle*
              *circularity-hash-table*
              (not (uniquely-identified-by-print-p object))
              (gethash object *circularity-hash-table*)
              t))
        (*circularity-hash-table*
         (multiple-value-bind (current presentp)
             (gethash object *circularity-hash-table*)
           (declare (ignore current))
           (setf (gethash object *circularity-hash-table*) presentp)))
        (t
         nil)))

(defmethod circle-detection-p (client stream)
  (declare (ignore client stream))
  (and *circularity-hash-table*
       (not *circularity-counter*)))

(defmethod write-unreadable-object
    (client object stream type identity function)
  (cond (*print-readably*
         (error 'print-not-readable :object object))
        (t
         (write-string "#<" stream)
         (when type
           (let (*print-circle* *print-length* *print-level*)
             (write-object client (type-of object) stream))
           (write-char #\space stream))
         (when function
           (funcall function))
         (when identity
           (when (or function (not type))
             (write-char #\space stream))
           (write-identity client object stream))
         (write-char #\> stream)))
  nil)

(defun write-read-eval (client object stream form type identity function)
  (cond ((and form
              *print-readably*
              *read-eval*)
         (write-string "#." stream)
         (write-object client form stream))
        (t
         (write-unreadable-object client object stream type identity function))))
