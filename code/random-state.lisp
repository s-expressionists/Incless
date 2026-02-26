(in-package #:incless)

(defun print-random-state (client state stream)
  (cond ((circle-detection-p client stream))
        ((and *print-readably*
              #-(or abcl ccl clasp ecl) (typep state 'structure-object))
         #+abcl (write-string (sys::%write-to-string state) stream)
         #+ccl (loop for val across (ccl::random.mrg31k3p-state state)
                       initially (write-string "#.(" stream)
                                 (write-object client 'ccl::initialize-mrg31k3p-state stream)
                     finally (write-char #\) stream)
                     do (write-char #\Space stream)
                        (write-object client val stream))
         #+clasp (core:write-ugly-object state stream)
         #+ecl (progn
                 (write-string "#$" stream)
                 (write-object client (si:random-state-array state) stream))
         #-(or abcl ccl clasp ecl) (print-structure client state stream))
        (t
         (write-unreadable-object client state stream t nil nil))))
