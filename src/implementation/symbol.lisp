(cl:in-package #:incless-implementation)

(defun print-lowercase-symbol (client name stream)
  (declare (ignore client))
  (loop for char across name
        do (write-char (char-downcase char) stream)))

(defun print-uppercase-symbol (client name stream)
  (declare (ignore client))
  (loop for char across name
        do (write-char (char-upcase char) stream)))

(defun print-capitalized-symbol (client name stream)
  (loop with prev-not-alphanum = t
        with up = (eq (readtable-case (incless:printer-readtable client)) :upcase)
        for char across name
        do (write-char (if up
                           (if (or prev-not-alphanum (lower-case-p char))
                               char
                               (char-downcase char))
                           (if prev-not-alphanum
                               (char-upcase char)
                               char))
                       stream)
           (setq prev-not-alphanum (not (alphanumericp char)))))

(defun print-inverted-symbol (client name stream)
  (loop with all-upper = t
        with all-lower = t
        for char across name
        finally (cond (all-upper
                       (print-lowercase-symbol client name stream))
                      (all-lower
                       (print-uppercase-symbol client name stream))
                      (t
                       (write-string name stream)))
        when (lower-case-p char)
          do (setf all-upper nil)
        when (upper-case-p char)
          do (setf all-lower nil)))

(defun print-cased-symbol (client name stream)
  (ecase (readtable-case (incless:printer-readtable client))
    (:upcase
     (ecase *print-case*
       (:upcase (write-string name stream))
       (:downcase (print-lowercase-symbol client name stream))
       (:capitalize (print-capitalized-symbol client name stream))))
    (:downcase
     (ecase *print-case*
       (:upcase (print-uppercase-symbol client name stream))
       (:downcase (write-string name stream))
       (:capitalize (print-capitalized-symbol client name stream))))
    (:preserve (write-string name stream))
    (:invert (print-inverted-symbol client name stream))))

(defun print-quoted-symbol (client name stream)
  (declare (ignore client))
  (loop for char across name
        initially (write-char #\| stream)
        finally (write-char #\| stream)
        when (or (char= char #\\) (char= char #\|))
          do (write-char #\\ stream)
        do (write-char char stream)))

(defun quote-symbol-p (client name)
  (loop with case = (readtable-case (incless:printer-readtable client))
        with all-digits = t
        with all-dots = t
        for char across name
        finally (return (or all-dots all-digits))
        when (or (find char "(),|\\`'\";:")
                 (and (lower-case-p char)
                      (eq case :upcase))
                 (and (upper-case-p char)
                      (eq case :downcase)))
          return t
        when (char/= char #\.)
          do (setf all-dots nil)
        when (not (digit-char-p char *print-base*))
          do (setf all-digits nil)))

(defun print-symbol-token (client name stream)
  (if (quote-symbol-p client name)
      (print-quoted-symbol client name stream)
      (print-cased-symbol client name stream)))

(defun print-symbol (client sym stream)
  (let ((package (symbol-package sym))
        (name (symbol-name sym)))
    (cond ((or *print-escape* *print-readably*)
           (cond ((null package)
                  (write-string "#:" stream))
                 ((eq package (load-time-value (find-package "KEYWORD")))
                  (write-string ":" stream))
                 ((eq package *package*))
                 (t
                  (multiple-value-bind (found status)
                      (find-symbol name)
                    (unless (and status
                                 (eq found symbol))
                      (print-symbol-token client (package-name package))
                      (write-string (if (eq (nth-value 1 (find-symbol name package)) :external)
                                        ":"
                                        "::")
                                    stream)))))
           (print-symbol-token client name stream))
          (t
           (print-cased-symbol client name stream)))))
