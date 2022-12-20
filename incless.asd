;;;; incless.asd

(asdf:defsystem #:incless
  :description "Core interface of printer"
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "interface")))))

