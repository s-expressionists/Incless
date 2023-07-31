;;;; incless.asd

(asdf:defsystem "incless-intrinsic"
  :description "A portable, extensible Common Lisp printer."
  :author "Lonjil <lonjil@gmail.com>"
  :license  "BSD"
  :version "0.0.1"
  :depends-on ("incless")
  :components ((:module "src"
                :pathname "src/intrinsic/"
                :serial t
                :components ((:file "package")
                             (:file "interface")
                             (:file "print-object")))))
