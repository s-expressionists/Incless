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
  (cond ((circle-detection-p client stream))
        ((zerop value)
         (when (minusp (float-sign value))
           (write-char #\- stream))
         (write-char (char *digit-chars* 0) stream)
         (write-char #\. stream)
         (write-char (char *digit-chars* 0) stream)
         (write-zero-exponent value stream))
        (t
         (multiple-value-bind (digits exponent sign)
             (quaviver:float-integer client 10 value)
           (setf digits (quaviver:integer-digits client 'vector 10 digits))
           (incf exponent (length digits))
           (when (minusp sign)
             (write-char #\- stream))
           (cond ((<= 1e-3 (abs value) 1e7)
                  (cond ((not (plusp exponent))
                         (write-char (char *digit-chars* 0) stream)
                         (write-char #\. stream)
                         (loop repeat (- exponent)
                               do (write-char (char *digit-chars* 0) stream))
                         (loop for digit across digits
                               do (write-char (char *digit-chars* digit) stream)))
                        ((< exponent (length digits))
                         (loop for digit across digits
                               for pos from 0
                               when (= pos exponent)
                                 do (write-char #\. stream)
                               do (write-char (char *digit-chars* digit) stream)))
                        (t
                         (loop for digit across digits
                               do (write-char (char *digit-chars* digit) stream))
                         (loop repeat (- exponent (length digits))
                               do (write-char (char *digit-chars* 0) stream))
                         (write-char #\. stream)
                         (write-char (char *digit-chars* 0) stream)))
                  (write-zero-exponent value stream))
                 (t
                  (loop for digit across digits
                        for pos from 0
                        when (= pos 1)
                          do (write-char #\. stream)
                        do (write-char (char *digit-chars* digit) stream))
                  (when (= (length digits) 1)
                    (write-char #\. stream)
                    (write-char (char *digit-chars* 0) stream))
                  (write-exponent-marker value stream)
                  (print-integer client (1- exponent) 10 nil stream)))))))
