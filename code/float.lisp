(in-package #:incless)

(defun write-exponent-marker (value stream)
  (write-char (if (typep value *read-default-float-format*)
                  #+abcl #\E #-abcl #\e
                  (etypecase value
                    (short-float
                     #+abcl #\S #-abcl #\s)
                    (single-float
                     #+abcl #\F #-abcl #\f)
                    (double-float
                     #+abcl #\D #-abcl #\d)
                    (long-float
                     #+abcl #\L #-abcl #\l)))
              stream))

(defun write-zero-exponent (value stream)
  (unless (typep value *read-default-float-format*)
    (write-exponent-marker value stream)
    (write-char (char *digit-chars* 0) stream)))

(defun print-float (client value stream)
  (unless (circle-detection-p client stream)
    (multiple-value-bind (significand exponent sign)
        (quaviver:float-integer client 10 value)
      (cond ((keywordp exponent)
             (write-read-eval client value stream
                              (ecase exponent
                                (:infinity
                                 (if (minusp sign)
                                     (etypecase value
                                       (single-float
                                        #+(or abcl clasp cmucl ecl)
                                        'ext:single-float-negative-infinity
                                        #+sbcl
                                        'sb-ext:single-float-negative-infinity)
                                       (double-float
                                        #+(or abcl clasp cmucl ecl)
                                        'ext:double-float-negative-infinity
                                        #+sbcl
                                        'sb-ext:double-float-negative-infinity)
                                       #+(and ecl long-float)
                                       (long-float
                                        'ext:long-float-negative-infinity))
                                     (etypecase value
                                       (single-float
                                        #+(or abcl clasp cmucl ecl)
                                        'ext:single-float-positive-infinity
                                        #+sbcl
                                        'sb-ext:single-float-positive-infinity)
                                       (double-float
                                        #+(or abcl clasp cmucl ecl)
                                        'ext:double-float-positive-infinity
                                        #+sbcl
                                        'sb-ext:double-float-positive-infinity)
                                       #+(and ecl long-float)
                                       (long-float
                                        'ext:long-float-positive-infinity))))
                                ((:quiet-nan :signaling-nan)
                                 #+abcl
                                 `(/ ,(coerce 0 (type-of value))
                                     ,(coerce 0 (type-of value)))
                                 #+allegro
                                 (etypecase value
                                   (single-float
                                    'excl:*nan-single*)
                                   (single-float
                                    'excl:*nan-double*))
                                 #+ecl
                                 `(coerce (sys:nan) ',(type-of value))))
                              t nil
                              (lambda ()
                                (write-object client exponent stream)
                                (write-char #\space stream)
                                (write-object client
                                              (if (eq exponent :infinity)
                                                  sign
                                                  significand)
                                              stream))))
            ((zerop significand)
             (when (minusp sign)
               (write-char #\- stream))
             (write-string "0.0" stream)
             (write-zero-exponent value stream))
            (t
             (let ((significand-length (quaviver.math:count-digits 10 significand)))
               (incf exponent significand-length)
               (when (minusp sign)
                 (write-char #\- stream))
               (cond ((<= 1e-3 (abs value) 1e7)
                      (quaviver:write-digits 10
                                             (if (< exponent significand-length)
                                                 significand
                                                 (* significand
                                                    (expt 10 (+ 1 exponent (- significand-length)))))
                                             stream
                                             :leading-zeros (if (plusp exponent) 0 1)
                                             :fractional-marker #\.
                                             :fractional-position exponent)
                      (write-zero-exponent value stream))
                     (t
                      (quaviver:write-digits 10
                                             (if (= significand-length 1)
                                                 (* 10 significand)
                                                 significand)
                                             stream
                                             :fractional-marker #\.
                                             :fractional-position 1)
                      (write-exponent-marker value stream)
                      (print-integer client (1- exponent) 10 nil stream)))))))))
