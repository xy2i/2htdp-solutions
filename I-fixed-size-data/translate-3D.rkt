;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname translate-3D) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct r3 [x y z])
; An R3 is a structure:
;   (make-r3 Number Number Number)
 
(define ex1 (make-r3 1 2 13))
(define ex2 (make-r3 -1 0 3))

; R3 -> Number
; computes the distance to 0 for an 3D-position
(check-within (r3-distance-to-0 ex1) (sqrt 174) 0.1)
(check-within (r3-distance-to-0 ex2) (sqrt 10) 0.1)
(define (r3-distance-to-0 p)
  (sqrt (+
         (sqr (r3-x p))
         (sqr (r3-y p))
         (sqr (r3-z p)))))