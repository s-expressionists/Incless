(cl:in-package #:incless-implementation)

(defun print-vector (client vec stream)
  (cond ((and (not *print-readably*)
              (eql 0 *print-level*))
         (write-char #\# stream))
        ((or *print-array* *print-readably*)
         (write-string "#(" stream)
         (loop :with *print-level* = (and *print-level* (max 0 (1- *print-level*)))
               :with l := (1- (length vec))
               :for i :below l
               :do (incless:write-object client (aref vec i) stream)
                   (write-char #\Space stream)
               :finally (incless:write-object client (aref vec l) stream))
         (write-string ")" stream))
        (t
         (incless:write-unreadable-object client vec stream t t nil)))
  vec)
