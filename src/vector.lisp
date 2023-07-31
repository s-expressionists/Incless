(cl:in-package #:incless)

(defun print-vector (client vec stream)
  (flet ((print-guts (openp)
           (when openp
             (write-char #\( stream))
           (loop with *print-level* = (and *print-level* (max 0 (1- *print-level*)))
                 for item across vec
                 for index from 0
                 unless (zerop index)
                   do (write-char #\Space stream)
                 if (or (null *print-length*)
                        *print-readably*
                        (< index *print-length*))
                   do (write-object client item stream)
                 else
                   do (write-string "..." stream)
                      (loop-finish))
           (write-char #\) stream)))
    (cond ((and (not *print-readably*)
                (eql 0 *print-level*))
           (write-char #\# stream))
          #+(or clasp clisp cmucl ecl mkcl)
          ((and *print-readably*
                (or (not (eq t (array-element-type vec)))
                    (some #'zerop (array-dimensions vec))))
           (write-string "#A(" stream)
           (write-object client (array-element-type vec) stream)
           (write-char #\Space stream)
           (write-object client (array-dimensions vec) stream)
           (write-char #\Space stream)
           (print-guts t)
           (write-char #\) stream))
          #+sbcl
          ((and *print-readably*
                (or (not (eq t (array-element-type vec)))
                    (some #'zerop (array-dimensions vec))))
           (write-string "#A(" stream)
           (write-object client (array-dimensions vec) stream)
           (write-char #\Space stream)
           (write-object client (array-element-type vec) stream)
           (write-char #\Space stream)
           (print-guts nil))
          ((or *print-array* *print-readably*)
           (write-char #\# stream)
           (print-guts t))
          (t
           (write-unreadable-object client vec stream t t nil)))))
