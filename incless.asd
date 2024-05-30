;;;; incless.asd

(asdf:defsystem "incless"
  :description "A portable and extensible Common Lisp printer implementation (core)"
  :license "BSD"
  :author ("Tarn W. Burton"
           "Robert Strandh"
           "Lonjil")
  :maintainer "Tarn W. Burton"
  :version (:read-file-form "version.sexp")
  :homepage "https://github.com/s-expressionists/Incless"
  :bug-tracker "https://github.com/s-expressionists/Incless/issues"
  :depends-on ("quaviver")
  :components ((:module "code"
                :serial t
                :components ((:file "package")
                             (:file "interface")
                             (:file "write-object")
                             (:file "integer")
                             (:file "rational")
                             (:file "float")
                             (:file "complex")
                             (:file "character")
                             (:file "string")
                             (:file "cons")
                             (:file "bit-vector")
                             (:file "array")
                             (:file "vector")
                             (:file "random-state")
                             (:file "pathname")
                             (:file "standard-object")
                             (:file "structure")
                             (:file "symbol")))))
