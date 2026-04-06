(in-package #:incless)

(defun print-package (client package stream)
  (let ((name (package-name package)))
    (write-unreadable-object client package stream t (not name)
                             (lambda ()
                               (if name
                                   (print-string client name stream)
                                   (write-string "(deleted)" stream))))))
