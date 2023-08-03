;;;; incless.asd

(asdf:defsystem "incless-extrinsic"
  :description "A portable, extensible Common Lisp printer."
  :author "Lonjil <lonjil@gmail.com>"
  :license  "BSD"
  :version "0.0.1"
  :depends-on ("incless")
  :in-order-to ((test-op (test-op "incless-extrinsic/test")))
  :components ((:module "src"
                :pathname "src/extrinsic/"
                :serial t
                :components ((:file "package")
                             (:file "interface")
                             (:file "print-object")))))

;;; This is really a test of the whole printer suite. It's not
;;; really possible to test the printer without testing the
;;; pretty printer at the same time so we might as well test
;;; format at the same time.
(defsystem "incless-extrinsic/test"
  :description "ANSI Test system for Inravina"
  :license "MIT"
  :author "Tarn W. Burton"
  :depends-on ("alexandria"
               "invistra-extrinsic")
  :perform (test-op (op c)
             (symbol-call :incless-extrinsic/test :test))
  :components ((:module "code"
                :pathname "src/extrinsic/test/"
                :serial t
                :components ((:file "packages")
                             (:file "test")))
               (:module "expected-failures"
                :pathname "src/extrinsic/test/expected-failures"
                :components ((:static-file "default.sexp")
                             (:static-file "abcl.sexp")
                             (:static-file "clasp.sexp")
                             (:static-file "ecl.sexp")
                             (:static-file "sbcl.sexp")))))
