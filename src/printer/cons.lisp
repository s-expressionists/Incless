(in-package #:incless)

(defmethod print-object-using-client ((client standard-client) (cons cons) stream)
  (if (and (not *print-readably*) *print-level* (>= *current-depth* *print-level*))
      (write-char #\# stream)
      (let ((*current-depth* (if *current-depth*
                                 (1+ *current-depth*)
                                 nil))
            (current-length 0)
            (x cons))
        (write-char #\( stream)
        (tagbody
         :2
           (write-object client (car x) stream)
           (incf current-length)
           (setf x (cdr x))
           (cond ((null x) (go :end))
                 ((not (consp x)) (go :4))
                 ((or *print-readably* (not *print-length*) (< current-length *print-length*))
                  (write-char #\Space stream)
                  (go :2))
                 (t (write-string " ..." stream)
                    (go :end)))
         :4
           (write-string " . " stream)
           (write-object client x stream)
         :end)
        (write-char #\) stream))))
