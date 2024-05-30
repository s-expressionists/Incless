(cl:in-package #:incless)

(defun print-pathname (client path stream)
  (flet ((print-guts ()
           (write-object client :host stream)
           (write-char #\Space stream)
           (write-object client (pathname-host path) stream)
           (write-char #\Space stream)
           (write-object client :device stream)
           (write-char #\Space stream)
           (write-object client (pathname-device path) stream)
           (write-char #\Space stream)
           (write-object client :directory stream)
           (write-char #\Space stream)
           (write-object client (pathname-directory path) stream)
           (write-char #\Space stream)
           (write-object client :name stream)
           (write-char #\Space stream)
           (write-object client (pathname-name path) stream)
           (write-char #\Space stream)
           (write-object client :type stream)
           (write-char #\Space stream)
           (write-object client (pathname-type path) stream)
           (write-char #\Space stream)
           (write-object client :version stream)
           (write-char #\Space stream)
           (write-object client (pathname-version path) stream)))
    (let ((namestring (ignore-errors (namestring path))))
      (cond ((and namestring
                  #-ccl (or (not *print-readably*)
                            (not (and (null (pathname-name path))
                                      (pathname-type path)))))
             (when (or *print-escape* *print-readably*)
               (write-string "#P" stream))
             (write-object client (namestring path) stream))
            ((and *read-eval* *print-readably*)
             (write-string "#.(" stream)
             (write-object client 'make-pathname stream)
             (write-char #\Space stream)
             (print-guts)
             (write-char #\) stream))
            (t
             (write-unreadable-object client path stream t nil #'print-guts))))))