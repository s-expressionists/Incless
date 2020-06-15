(in-package #:incless)

(a:define-constant +alphabet+ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" :test 'string=)

(defun write-integer-digits (integer stream &aux (integer (abs integer)))
  (let* ((width (floor (1+ (log integer *print-base*))))
         (buffer (make-string width)))
    (loop :for x := integer :then (floor x *print-base*)
          :for i :from 0
          :while (< i width)
          :for d := (mod x *print-base*)
          :do (setf (aref buffer (- width i 1)) (aref +alphabet+ d)))
    (write-string buffer stream)))

(defun write-radix (base stream)
  (write-char #\# stream)
  (cond ((= base 2) (write-char #\b))
        ((= base 8) (write-char #\o))
        ((= base 16) (write-char #\x))
        (t (let ((*print-base* 10)) (write-integer-digits base stream))
           (write-string "r"))))

(defun write-sign (integer stream)
  (when (minusp integer)
    (write-char #\- stream)))

(defmethod print-object-using-client ((client standard-client) (object integer) stream)
  (when (and *print-radix* (not (= *print-base* 10)))
    (write-radix *print-base* stream))
  (write-sign object stream)
  (write-integer-digits object stream)
  (when (and *print-radix* (= *print-base* 10))
    (write-char #\.))
  object)
