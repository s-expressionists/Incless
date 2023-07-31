(in-package #:incless)

(defclass decimal ()
  ((%digits :accessor decimal-digits
            :initarg :digits)
   (%position :accessor decimal-position
              :initarg :position
              :initform 0)))

(defun round-decimal (decimal count)
  (with-accessors ((decimal-digits decimal-digits)
                   (decimal-position decimal-position))
      decimal
    (when (and (< (+ decimal-position count) (length decimal-digits))
               (< -1 (+ decimal-position count) (length decimal-digits))
               (> (aref decimal-digits (+ decimal-position count)) 4))
      (loop for pos = (+ decimal-position count -1)
            for (carry new-digit) = (multiple-value-list (floor (1+ (aref decimal-digits pos)) 10))
            do (setf (aref decimal-digits pos) new-digit)
            when (zerop carry)
              do (loop-finish)
            when (zerop pos)
              do (setf decimal-digits (concatenate 'vector #(1) decimal-digits))
                 (incf decimal-position)
                 (loop-finish)))
    (setf decimal-digits
          (subseq decimal-digits 0 (+ decimal-position (max 0 count))))))

(defun print-decimal (decimal stream)
  (loop with d-pos = (decimal-position decimal)
        with len = (length (decimal-digits decimal))
        for digit across (decimal-digits decimal)
        for pos from 0
        finally (when (= d-pos len)
                  (write-char #\. stream))
        when (= pos d-pos)
          do (write-char #\. stream)
        do (write-char (aref *digits* digit) stream)))

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
         (when (minusp (float-sign value))
           (write-char #\- stream))
         (write-string "0.0" stream)
         (write-zero-exponent value stream))
        (t
         (when (minusp (float-sign value))
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
