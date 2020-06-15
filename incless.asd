;;;; incless.asd

(asdf:defsystem #:incless
  :description "A portable, extensible Common Lisp printer."
  :author "Lonjil <lonjil@gmail.com>"
  :license  "BSD"
  :version "0.0.1"
  :depends-on ("alexandria"
               "acclimation")
  :components ((:module "printer"
                :pathname "src/printer/"
                :serial t
                :components ((:file "package")
                             (:file "interface")
                             (:file "integer")
                             (:file "rational")
                             (:file "float")
                             (:file "complex")
                             (:file "character")))))
