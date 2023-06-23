(in-package #:incless-implementation)

(defun print-structure (client object stream)
  (if *print-readably*
      (loop with class = (class-of object)
            for name in (incless:class-slot-names client class)
            for index from 0
            initially (write-string "#S(" stream)
                      (let (*print-circle* *print-length* *print-level*)
                        (incless:write-object client (class-name class) stream))
            finally (write-string ")" stream)
            when (and *print-length*
                      (>= index *print-length*))
              do (write-string " ...")
                 (loop-finish)
            do (write-char #\Space stream)
               (incless:write-object client (intern (symbol-name name) :keyword)
                                     stream)
               (write-char #\Space stream)
               (incless:write-object client
                                     (slot-value object name)
                                     stream))
      (incless:write-unreadable-object client object stream t t nil)))
