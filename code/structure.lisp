(in-package #:incless)

(defun print-structure (client object stream)
  (cond ((and (not *print-readably*)
              (eql 0 *print-level*))
         (write-char #\# stream))
        ((or (typep object 'condition)
             (packagep object)
             (hash-table-p object)
             #+sbcl (sb-impl::funcallable-instance-p object))
         (write-unreadable-object client object stream t t nil))
        (t
         (write-string "#S(" stream)
         (if (and (not *print-readably*)
                  (equal *print-length* 0))
             (write-string "..." stream)
             (loop with class = (class-of object)
                   with *print-level* = (and *print-level*
                                             (max 0 (1- *print-level*)))
                   for name in (class-slot-names client class)
                   for index from 1 by 2
                   initially (let ((*print-escape* t))
                               (write-object client (class-name class) stream))
                   unless (or (null *print-length*)
                              *print-readably*
                              (< index *print-length*))
                     do (write-string " ..." stream)
                        (loop-finish)
                   do (write-char #\Space stream)
                      (let ((*print-escape* t))
                        (write-object client (intern (symbol-name name) :keyword)
                                      stream))
                   unless (or (null *print-length*)
                              *print-readably*
                              (< (1+ index) *print-length*))
                     do (write-string " ..." stream)
                        (loop-finish)
                   do (write-char #\Space stream)
                      (write-object client
                                    (slot-value object name)
                                    stream)))
         (write-string ")" stream))))
