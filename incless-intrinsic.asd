(asdf:defsystem "incless-intrinsic"
  :description "A portable and extensible Common Lisp printer implementation (intrinsic interface)"
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
  :components ((:module "code"
                :pathname "code/intrinsic/"
                :serial t
                :components ((:file "package")
                             (:file "interface")))))
