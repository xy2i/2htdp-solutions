;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 150-add-to-pi) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N -> Number
; computes (+ n pi) without using +
(check-within (add-to-pi 3) (+ 3 pi) 0.001)
(check-within (add-to-pi 0) pi 0.001)
 
(define (add-to-pi n)
  (cond
    [(zero? n) pi]
    [(positive? n) (add1 (add-to-pi (sub1 n)))]))

; N Number -> Number
; computes (+ n number) without +
(check-expect (add-to-number 2 1.5) 3.5)
(define (add-to-number n number)
  (cond
    [(zero? n) number]
    [(positive? n) (add1 (add-to-number (sub1 n) number))]))
  
;; Ex. 150: Why does the test use check-expect?
; We are dealing with inexact numbers, and pi is one.
; An addition an inexact number is not guantreed to be exact.