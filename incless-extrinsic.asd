(asdf:defsystem "incless-extrinsic"
  :description "A portable and extensible Common Lisp printer implementation (extrinsic interface)"
  :license "BSD"
  :author ("Tarn W. Burton"
           "Robert Strandh"
           "Lonjil")
  :maintainer "Tarn W. Burton"
  :version (:read-file-form "version.sexp")
  :homepage "https://github.com/s-expressionists/Incless"
  :bug-tracker "https://github.com/s-expressionists/Incless/issues"
  :depends-on ("incless"
               "quaviver/burger-dybvig")
  :in-order-to ((test-op (test-op "incless-extrinsic/test")))
  :components ((:module "code"
                :pathname "code/extrinsic/"
                :serial t
                :components ((:file "package")
                             (:file "interface")))))

;;; This is really a test of the whole printer suite. It's not
;;; really possible to test the printer without testing the
;;; pretty printer at the same time so we might as well test
;;; format at the same time.
(defsystem "incless-extrinsic/test"
  :description "ANSI Test system for Incless"
  :license "BSD"
  :author ("Tarn W. Burton"
           "Robert Strandh"
           "Lonjil")
  :maintainer "Tarn W. Burton"
  :version (:read-file-form "version.sexp")
  :homepage "https://github.com/s-expressionists/Incless"
  :bug-tracker "https://github.com/s-expressionists/Incless/issues"
  :depends-on ("ansi-test-harness"
               "invistra-extrinsic")
  :perform (test-op (op c)
             (symbol-call :incless-extrinsic/test :test))
  :components ((:module "code"
                :pathname "code/extrinsic/test/"
                :serial t
                :components ((:file "packages")
                             (:file "test")
                             (:static-file "expected-failures.sexp")))))
