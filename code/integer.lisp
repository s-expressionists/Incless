(in-package #:incless)

(defparameter *digit-chars* "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")

;;; We want to print a positive integer in any base, but we don't want
;;; to use a buffer of digits.  The basic technique we are using is
;;; that we recursively print the most significant digits first, and
;;; then the least significant digits, in a way that roughly half the
;;; digits are printed in earch recursive call.  Suppose there are D
;;; digits to print.  Then we want to split D into two integers Du and
;;; Dl, such that Du + Dl = D, and Du and Dl are roughly D/2.  The
;;; closer to D/2 we get, the fewer recursive calls we need.
;;; Furthermore, Du and Dl must both be greater than 0, or else we
;;; have an infinite recursion.
;;;
;;; Once we have Du and Dl, we can compute two numbers Nu and Nl as
;;; the values of (floor N B^Dl).  We then recursively print Nu first
;;; and then Nl.
;;;
;;; To get the number of digits in a number N, using a particular base
;;; B, we could use logarithms.  But logarithms are expensive to
;;; compute, and could be tricky to get right for bignums.  As it
;;; turns out, INTEGER-LENGTH is a reasonable approximation of the
;;; logarithm (base 2) of a number.  Let IN be the INTEGER-LENGTH of N
;;; and IB be the INTEGER-LENGTH of B.  If we divide the IN by IB, we
;;; get a rough approximation of the number of digits in N.  The
;;; problem is that for small values of B, in particular 2 and 3, the
;;; approximation is not that great.  A very good approximation for
;;; all values of B from 2 to 36 happens to be: (FLOOR (ASH IN 1) (1-
;;; (INTEGER-LENGTH (* B B)))).  By doubling IN and using the
;;; INTEGER-LENGTH of the square of the base (minus 1), we trick FLOOR
;;; into giving us a better approximation than if we simply use IN and
;;; IB.
;;;
;;; Since the computation of D is approximate, the only thing we know
;;; with absolute certainty is that Nl has exactly Dl digits.  So for
;;; Nl, we do not have to redo the computation of the number of
;;; digits.  But since Du is just D - Dl, Du is also approximate.
;;; When we print Nu, we must therefore redo the calculation of the
;;; number of digits.  This difference is reflected by two different
;;; lexical functions, one for printing upper halves and one for
;;; printing lower halves.

(defun write-integer-digits (integer base stream)
  (let ((divisor (1- (integer-length (* base base)))))
    (labels ((upper (integer)
               (if (< integer base)
                   (write-char (char *digit-chars* integer) stream)
                   (let* ((binary-length (integer-length integer))
                          (length (max 2 (floor (ash binary-length 1) divisor)))
                          (length/2 (floor length 2))
                          (split (expt base length/2)))
                     (multiple-value-bind (quotient remainder)
                         (floor integer split)
                       (upper quotient)
                       (lower remainder length/2)))))
             (lower (integer length)
               (if (= length 1)
                   (write-char (char *digit-chars* integer) stream)
                   (let* ((length/2 (floor length 2))
                          (split (expt base length/2)))
                     (multiple-value-bind (quotient remainder)
                         (floor integer split)
                       (lower quotient  (- length length/2))
                       (lower remainder length/2))))))
      (upper integer))))

(defun write-integer-digits-alt (integer base stream)
  (cond ((= (logcount base) 1)
         (prog* ((size (integer-length (1- base)))
                 (position (* size (1- (ceiling (integer-length integer) size)))))
          print
            (unless (minusp position)
              (write-char (char *digit-chars* (ldb (byte size position) integer)) stream)
              (decf position size)
              (go print))))
        ((typep integer 'fixnum)
         (labels ((write-digit (value)
                    (multiple-value-bind (q r)
                        (floor value base)
                      (unless (zerop q)
                        (write-digit q))
                      (write-char (char *digit-chars* r) stream))))
           (write-digit integer)))
        (t
         (prog ((q integer) (r 0) result)
          repeat
            (multiple-value-setq (q r) (floor q base))
            (push (char *digit-chars* r) result)
            (unless (zerop q)
              (go repeat))
          print
            (when result
              (write-char (pop result) stream)
              (go print))))))

(defun write-radix (radix stream)
  (case radix
    (2
     (write-string "#b" stream))
    (8
     (write-string "#o" stream))
    (10
     (write-string "" stream))
    (16
     (write-string "#x" stream))
    (otherwise
     (write-char #\# stream)
     (write-integer-digits-alt *print-base* 10 stream)
     (write-char #\r stream))))

(defun write-sign (integer stream)
  (when (minusp integer)
    (write-char #\- stream)))

(defun print-integer (client integer base radix stream)
  ;; Determine whether a radix prefix should be printed, and if so,
  ;; which one.
  (unless (circle-detection-p client stream)
    (when radix
      (write-radix base stream))
    (cond ((zerop integer)
           (write-char (char *digit-chars* 0) stream))
          ((minusp integer)
           (write-sign integer stream)
           (write-integer-digits-alt (- integer) base stream))
          (t
           (write-integer-digits-alt integer base stream)))
    ;; Determine whether a trailing dot should be printed.
    (when (and radix (= base 10))
      (write-char #\. stream))))
