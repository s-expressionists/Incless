(in-package #:incless)

(define-condition print-not-readable-unimplementable (print-not-readable)
  ()
  (:report (lambda (condition stream)
             (format stream "A readable printer for ~S cannot be implemented ~
portably by Incless." (print-not-readable-object condition)))))
