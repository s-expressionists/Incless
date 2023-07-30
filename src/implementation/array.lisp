(cl:in-package #:incless-implementation)

(defun print-array (client arr stream)
  (labels ((print-guts (indicies dimensions *print-level*
                        &optional (openp t))
             (cond ((null dimensions)
                    (incless:write-object client (apply #'aref arr indicies) stream))
                   ((and (not *print-readably*)
                         (equal *print-level* 0))
                    (write-char #\# stream))
                   (t
                    (loop for index below (first dimensions)
                          initially (when openp
                                      (write-char #\( stream))
                          finally (write-char #\) stream)
                          unless (zerop index)
                            do (write-char #\Space stream)
                          unless (or *print-readably*
                                     (null *print-length*)
                                     (< index *print-length*))
                            do (write-string "..." stream)
                               (loop-finish)
                          do (print-guts (append indicies (list index))
                                         (cdr dimensions)
                                         (and *print-level*
                                              (max 0 (1- *print-level*)))))))))
    (cond ((and (not *print-readably*)
                (equal *print-level* 0))
           (write-char #\# stream))
          #+sbcl
          ((and *print-readably*
                (or (not (eq t (array-element-type arr)))
                    (some #'zerop (array-dimensions arr))))
           (write-string "#A(" stream)
           (incless:write-object client (array-dimensions arr) stream)
           (write-char #\Space stream)
           (incless:write-object client (array-element-type arr) stream)
           (cond ((zerop (array-rank arr))
                  (write-string " . " stream)
                  (incless:write-object client (aref arr) stream)
                  (write-char #\) stream))
                 (t
                  (print-guts '() (array-dimensions arr) *print-level* nil))))
          ((or *print-array* *print-readably*)
           (write-char #\# stream)
           (write-integer-digits (array-rank arr) 10 stream)
           (write-char #\A stream)
           (print-guts '() (array-dimensions arr) *print-level*))
          (t
           (incless:write-unreadable-object client arr stream t t nil)))))
