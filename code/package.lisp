(in-package #:incless)

(defun print-package (client package stream)
  (write-unreadable-object client package stream t nil
                           (lambda ()
                             (print-string client (package-name package) stream))))
