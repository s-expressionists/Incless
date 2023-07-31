(in-package #:incless)

(defun print-random-state (client state stream)
  (if (and *print-readably*
           #-(or abcl clasp ecl) (typep state 'structure-object))
      #+abcl (write-string (sys::%write-to-string state) stream)
      #+clasp (core:write-ugly-object state stream)
      #+ecl (progn
              (write-string "#$" stream)
              (write-object client (si:random-state-array state) stream))
      #-(or abcl clasp ecl) (print-structure client state stream)
      (write-unreadable-object client state stream t nil nil)))
