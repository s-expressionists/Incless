(cl:in-package #:incless)

;;; none of these are required to be printed readably by the spec.
;; (def-identical-printers (foo (hash-table readtable package stream function))
;;   (if *print-readably*
;;       (error 'print-not-readable :object foo)
;;       (unreadably client foo stream)))
