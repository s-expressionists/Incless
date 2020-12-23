;;;; incless.asd

(asdf:defsystem "incless-intrinsic"
  :description "A portable, extensible Common Lisp printer."
  :author "Lonjil <lonjil@gmail.com>"
  :license  "BSD"
  :version "0.0.1"
  :depends-on ("alexandria")
  :components ((:module "interface"
                :pathname "src/interface/"
                :serial t
                :components ((:file "package-intrinsic")
                             (:file "parameters")
                             (:file "conditions")
                             (:file "interface")))
               (:module "printer"
                :pathname "src/printer/"
                :depends-on ("interface")
                :serial t
                :components ((:file "utilities")
                             (:file "integer")
                             (:file "rational")
                             (:file "float")
                             (:file "complex")
                             (:file "character")
                             (:file "string")
                             (:file "cons")
                             (:file "bit-vector")
                             (:file "vector")
                             (:file "array")
                             (:file "random-state")
                             (:file "standard-object")
                             (:file "structure")
                             (:file "unreadable-stubs")))))
