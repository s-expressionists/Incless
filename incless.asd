;;;; incless.asd

(asdf:defsystem #:incless
  :description "Core interface of printer"
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "interface")
                             (:file "write-object")
                             (:file "integer")
                             (:file "rational")
                             (:file "burger-dybvig")
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
