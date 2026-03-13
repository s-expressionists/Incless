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
  :depends-on ("incless")
  :components ((:module "code"
                :pathname "code/extension/"
                :serial t
                :components ((:file "packages")
                             (:file "implementation")))))
