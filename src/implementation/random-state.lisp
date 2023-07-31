(in-package #:incless-implementation)

(defun print-random-state (client state stream)
  (if (and *print-readably*
           #-clasp (typep state 'structure-object))
      #+clasp (core:write-ugly-object state stream)
      #-clasp (print-structure client state stream)
      (incless:write-unreadable-object client state stream t nil nil)))
