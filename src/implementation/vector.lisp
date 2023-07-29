(cl:in-package #:incless-implementation)

(defun print-vector (client vec stream)
  (cond ((and (not *print-readably*)
              (eql 0 *print-level*))
         (write-char #\# stream))
        ((or *print-array* *print-readably*)
         (write-string "#(" stream)
         (loop with *print-level* = (and *print-level* (max 0 (1- *print-level*)))
               for item across vec
               for index from 0
               unless (zerop index)
                 do (write-char #\Space stream)
               if (or (null *print-length*)
                      (< index *print-length*))
                 do (incless:write-object client item stream)
               else
                 do (write-string "..." stream)
                    (loop-finish))
         (write-string ")" stream))
        (t
         (incless:write-unreadable-object client vec stream t t nil)))
  vec)
