(in-package #:incless-implementation)

(defun print-cons (client cons stream)
  (if (and (not *print-readably*)
           (eql 0 *print-level*))
      (write-char #\# stream)
      (let ((*print-level* (and *print-level*
                                (max 0 (1- *print-level*))))
            (current-length 0)
            (x cons))
        (write-char #\( stream)
        (tagbody
         :2
           (when (and (not *print-readably*)
                      (equal 0 *print-length*))
             (write-string "..." stream)
             (go :end))
           (incless:write-object client (car x) stream)
           (incf current-length)
           (setf x (cdr x))
           (cond ((null x)
                  (go :end))
                 ((or (not (consp x))
                      (circle-check client x stream))
                  (go :4))
                 ((or *print-readably*
                      (not *print-length*)
                      (< current-length *print-length*))
                  (write-char #\Space stream)
                  (go :2))
                 (t
                  (write-string " ..." stream)
                  (go :end)))
         :4
           (write-string " . " stream)
           (incless:write-object client x stream)
         :end)
        (write-char #\) stream))))
