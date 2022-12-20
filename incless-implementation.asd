(asdf:defsystem #:incless-implementation
  :description "A portable, extensible Common Lisp printer."
  :author "Lonjil <lonjil@gmail.com>"
  :license  "BSD"
  :version "0.0.1"
  :depends-on (#:incless)
  :components ((:module "src"
                :pathname "src/implementation/"
                :serial t
                :components ((:file "package")
                             (:file "conditions")
                             (:file "write-object")
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
                             (:file "pathname")
                             (:file "standard-object")
                             (:file "structure")
                             (:file "symbol")))))
