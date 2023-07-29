(in-package #:incless-implementation)

(defun write-exponent-marker (value stream)
  (write-char (if (typep value *read-default-float-format*)
                  #\e
                  (etypecase value
                    (short-float #\s)
                    (single-float #\f)
                    (double-float #\d)
                    (long-float #\l)))
              stream))

(defun write-zero-exponent (value stream)
  (unless (typep value *read-default-float-format*)
    (write-exponent-marker value stream)
    (write-char #\0 stream)))

(defun print-float (client value stream)
  (cond ((circle-detection-p client stream))
        ((zerop value)
         (when (minusp value)
           (write-char #\- stream))
         (write-string "0.0" stream)
         (write-zero-exponent value stream))
        (t
         (when (minusp value)
           (write-char #\- stream))
         (multiple-value-bind (digits exponent)
             (burger-dybvig-2 value)
           (cond ((<= 1e-3 (abs value) 1e7)
                  (cond ((not (plusp exponent))
                         (write-string "0." stream)
                         (loop repeat (- exponent)
                               do (write-char #\0 stream))
                         (loop for digit across digits
                               do (write-char (elt *digits* digit) stream)))
                        ((< exponent (length digits))
                         (loop for digit across digits
                               for pos from 0
                               when (= pos exponent)
                                 do (write-char #\. stream)
                               do (write-char (elt *digits* digit) stream)))
                        (t
                         (loop for digit across digits
                               do (write-char (elt *digits* digit) stream))
                         (loop repeat (- exponent (length digits))
                               do (write-char #\0 stream))
                         (write-string ".0" stream)))
                  (write-zero-exponent value stream))
                 (t
                  (loop for digit across digits
                        for pos from 0
                        when (= pos 1)
                          do (write-char #\. stream)
                        do (write-char (elt *digits* digit) stream))
                  (write-exponent-marker value stream)
                  (print-integer client (1- exponent) 10 nil stream)))))))
