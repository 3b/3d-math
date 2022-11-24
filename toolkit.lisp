#|
 This file is a part of 3d-matrices
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.matrices)

;; We choose this limit in order to ensure that matrix indices
;; always remain within fixnum range. I'm quite certain you don't
;; want to use matrices as big as this allows anyway. You'll want
;; BLAS/LAPACK and/or someone much smarter than me for that.
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defvar *matrix-limit* (min (floor (sqrt array-dimension-limit))
                              (floor (sqrt most-positive-fixnum)))))

(defvar *eps* 0.00001f0)
(defvar *deps* 0.00000000001d0)
(declaim (type single-float *eps*))
(declaim (type double-float *deps*))

(deftype mat-dim ()
  '(integer 0 #.(1- *matrix-limit*)))

(declaim (inline ensure-function))
(defun ensure-function (functionish)
  (etypecase functionish
    (function functionish)
    (symbol (fdefinition functionish))))

(declaim (inline ~=))
(defun ~= (a b)
  (< (abs (- a b)) *eps*))

(declaim (inline ~/=))
(defun ~/= (a b)
  (<= *eps* (abs (- a b))))

(defmacro do-times ((var start end &optional (by 1) return) &body body)
  (if (and (integerp start) (integerp end))
      `(progn
         ,@(loop for i from start below end by by
                 collect `(let ((,var ,i)) ,@body))
         ,return)
      `(loop for i from ,start below ,end by ,by
             do (progn ,@body)
             finally (return ,return))))
