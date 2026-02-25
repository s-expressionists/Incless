(in-package #:incless-extrinsic/test)

(defclass extrinsic-test-client (invistra-extrinsic::extrinsic-client-impl) ())

(defvar *tests*
  '("COPY-PPRINT-DISPATCH."
    "FORMAT."
    "FORMATTER."
    "PPRINT."
    "PPRINT-DISPATCH."
    "PPRINT-EXIT-IF-LIST-EXHAUSTED."
    "PPRINT-FILL."
    "PPRINT-INDENT."
    "PPRINT-LINEAR."
    "PPRINT-LOGICAL-BLOCK."
    "PPRINT-NEWLINE."
    "PPRINT-POP."
    "PPRINT-TAB."
    "PPRINT-TABULAR."
    "PRIN1."
    "PRIN1-TO-STRING."
    "PRINC."
    "PRINC-TO-STRING."
    "PRINT."
    "PRINT-BASE."
    "PRINT-CASE."
    "PRINT-CIRCLE."
    "PRINT-ESCAPE."
    "PRINT-GENSYM."
    "PRINT-LENGTH."
    "PRINT-LEVEL."
    "PRINT-LINES."
    "PRINT-RADIX."
    "PRINT-READABLY."
    "PRINT-RIGHT-MARGIN."
    "PRINT-STRUCTURE."
    "PRINT-UNREADABLE-OBJECT."
    "SET-PPRINT-DISPATCH."
    "WRITE."
    "WRITE-TO-STRING."))

(defvar *extrinsic-symbols*
  '(incless-extrinsic:pprint
    incless-extrinsic:prin1
    incless-extrinsic:prin1-to-string
    incless-extrinsic:princ
    incless-extrinsic:princ-to-string
    incless-extrinsic:print
    incless-extrinsic:print-object
    incless-extrinsic:print-unreadable-object
    incless-extrinsic:write
    incless-extrinsic:write-to-string
    inravina-extrinsic:*print-pprint-dispatch*
    inravina-extrinsic:copy-pprint-dispatch
    inravina-extrinsic:pprint-dispatch
    inravina-extrinsic:pprint-exit-if-list-exhausted
    inravina-extrinsic:pprint-fill
    inravina-extrinsic:pprint-indent
    inravina-extrinsic:pprint-linear
    inravina-extrinsic:pprint-logical-block
    inravina-extrinsic:pprint-newline
    inravina-extrinsic:pprint-pop
    inravina-extrinsic:pprint-tab
    inravina-extrinsic:pprint-tabular
    inravina-extrinsic:set-pprint-dispatch
    inravina-extrinsic:with-standard-io-syntax
    invistra-extrinsic:format
    invistra-extrinsic:formatter))

(defmethod invistra:coerce-function-designator ((client extrinsic-test-client) object)
  (or (find object *extrinsic-symbols*
            :test (lambda (x y)
                    (equal (string x) (string y))))
      object))

(defun test (&rest args)
  (let ((system (asdf:find-system :incless-extrinsic/test))
        (incless-extrinsic:*client* (make-instance 'extrinsic-test-client)))
    (apply #'ansi-test-harness:ansi-test
           :directory (merge-pathnames (make-pathname :directory '(:relative "dependencies" "ansi-test"))
                                       (asdf:component-pathname system))
           :expected-failures (asdf:component-pathname (asdf:find-component system
                                                                            '("code" "expected-failures.sexp")))
           :extrinsic-symbols *extrinsic-symbols*
           :tests *tests*
           args)))
