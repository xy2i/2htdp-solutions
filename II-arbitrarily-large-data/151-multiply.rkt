;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 151-multiply) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N Number -> Number
; calculates x times n, without using *
(check-expect (multiply 4 2.5) 10)
(define (multiply n number)
  (cond
    [(zero? n) 0] ; a number times zero is itself
    [(positive? n) (+ number (multiply (sub1 n) number))]))