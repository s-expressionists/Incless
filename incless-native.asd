(asdf:defsystem "incless-native"
  :description "Native implementation of Incless"
  :depends-on ("incless")
  :components ((:module "src"
                :pathname "src/native/"
                :serial t
                :components ((:file "package")
                             (:file "implementation")))))

