(in-package #:incless-extrinsic/test)

(defun check-repo (&key directory repository &allow-other-keys)
  (format t "~:[Did not find~;Found~] ~A clone in ~A, assuming everything is okay.~%"
          (probe-file directory) repository directory))

(defun sync-repo (&key (git "git") clean directory repository branch commit
                  &allow-other-keys
                  &aux (exists (probe-file directory)))
  (cond ((and exists (not clean))
         (format t "Fetching ~A~%" repository)
         (uiop:run-program (list git "fetch" "--quiet")
                           :output :interactive
                           :error-output :output
                           :directory directory))
        (t
         (when (and clean exists)
           (format t "Removing existing directory ~A~%" directory)
           (uiop:delete-directory-tree exists :validate t))
         (format t "Cloning ~A~%" repository)
         (uiop:run-program (list git "clone" repository (namestring directory))
                           :output :interactive
                           :error-output :output)))
  (when (or commit branch)
    (format t "Checking out ~A from ~A~%" (or commit branch) repository)
    (uiop:run-program (list git "checkout" "--quiet" (or commit branch))
                      :output :interactive
                      :error-output :output
                      :directory directory))
  (when (and branch (not commit))
    (format t "Fast forwarding to origin/~A from ~A~%" branch repository)
    (uiop:run-program (list git "merge" "--ff-only" (format nil "origin/~A" branch))
                      :output :interactive
                      :error-output :output
                      :directory directory)))

(defvar +ansi-test-repository+ "https://gitlab.common-lisp.net/ansi-test/ansi-test.git")

(defvar *tests*
  '("COPY-PPRINT-DISPATCH."
    "FORMAT."
    "FORMATTER."
    "PPRINT."
    "PPRINT-DISPATCH."
    "PPRINT-EXIT-IF-LIST-EXHAUSTED."
    "PPRINT-FILL."
    "PPRINT-INDENT."
    "PPRINT-LINEAR."
    "PPRINT-LOGICAL-BLOCK."
    "PPRINT-NEWLINE."
    "PPRINT-POP."
    "PPRINT-TAB."
    "PPRINT-TABULAR."
    "PRIN1."
    "PRIN1-TO-STRING."
    "PRINC."
    "PRINC-TO-STRING."
    "PRINT."
    "PRINT-BASE."
    "PRINT-CASE."
    "PRINT-CIRCLE."
    "PRINT-ESCAPE."
    "PRINT-GENSYM."
    "PRINT-LENGTH."
    "PRINT-LEVEL."
    "PRINT-LINES."
    "PRINT-RADIX."
    "PRINT-READABLY."
    "PRINT-RIGHT-MARGIN."
    "PRINT-STRUCTURE."
    "PRINT-UNREADABLE-OBJECT."
    "SET-PPRINT-DISPATCH."
    "WRITE."
    "WRITE-TO-STRING."))

(defun test (&rest args &key skip-sync &allow-other-keys)
  (let* ((system (asdf:find-system :incless-extrinsic/test))
         (expected-failures (asdf:component-pathname (asdf:find-component system '("expected-failures"
                                                                                   #+abcl "abcl.sexp"
                                                                                   #+clasp "clasp.sexp"
                                                                                   #+ecl "ecl.sexp"
                                                                                   #+sbcl "sbcl.sexp"
                                                                                   #-(or abcl clasp ecl sbcl)
                                                                                   "default.sexp"))))
         (*default-pathname-defaults* (merge-pathnames (make-pathname :directory '(:relative "dependencies" "ansi-test"))
                                                       (asdf:component-pathname system)))
         (cl-user::*extrinsic-symbols* '(incless-extrinsic:pprint
                                         incless-extrinsic:prin1
                                         incless-extrinsic:prin1-to-string
                                         incless-extrinsic:princ
                                         incless-extrinsic:princ-to-string
                                         incless-extrinsic:print
                                         incless-extrinsic:print-object
                                         incless-extrinsic:print-unreadable-object
                                         incless-extrinsic:write
                                         incless-extrinsic:write-to-string
                                         inravina-extrinsic:*print-pprint-dispatch*
                                         inravina-extrinsic:copy-pprint-dispatch
                                         inravina-extrinsic:pprint-dispatch
                                         inravina-extrinsic:pprint-exit-if-list-exhausted
                                         inravina-extrinsic:pprint-fill
                                         inravina-extrinsic:pprint-indent
                                         inravina-extrinsic:pprint-linear
                                         inravina-extrinsic:pprint-logical-block
                                         inravina-extrinsic:pprint-newline
                                         inravina-extrinsic:pprint-pop
                                         inravina-extrinsic:pprint-tab
                                         inravina-extrinsic:pprint-tabular
                                         inravina-extrinsic:set-pprint-dispatch
                                         inravina-extrinsic:with-standard-io-syntax
                                         invistra-extrinsic:format
                                         invistra-extrinsic:formatter)))
    (declare (special cl-user::*extrinsic-symbols*))
    (if skip-sync
        (check-repo :directory *default-pathname-defaults* :repository +ansi-test-repository+)
        (apply #'sync-repo :directory *default-pathname-defaults* :repository +ansi-test-repository+ args))
    (load #P"init.lsp")
    (dolist (name (mapcar (lambda (entry)
                            (uiop:symbol-call :regression-test :name entry))
                          (cdr (symbol-value (find-symbol "*ENTRIES*" :regression-test)))))
      (unless (member (symbol-name name) *tests*
                      :test (lambda (name prefix)
                              (alexandria:starts-with-subseq prefix name)))
        (uiop:symbol-call :regression-test :rem-test name)))
    (uiop:symbol-call :regression-test :do-tests :exit t :expected-failures expected-failures)))
