(in-package #:incless-implementation)

(defun print-random-state (client state stream)
  (if (and *print-readably*
           #-(or clasp ecl) (typep state 'structure-object))
      #+clasp (core:write-ugly-object state stream)
      #+ecl (progn
              (write-string "#$" stream)
              (incless:write-object client (si:random-state-array state) stream))
      #-(or clasp ecl) (print-structure client state stream)
      (incless:write-unreadable-object client state stream t nil nil)))
