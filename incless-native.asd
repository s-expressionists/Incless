(asdf:defsystem "incless-native"
  :description "Native implementation of Incless"
  :depends-on ("incless")
  :components ((:module "code"
                :pathname "code/native/"
                :serial t
                :components ((:file "package")
                             (:file "implementation")))))

