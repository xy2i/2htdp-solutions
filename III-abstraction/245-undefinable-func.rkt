;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 245-undefinable-func) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (a x) x)

(check-expect (function=at-1.2-3-and-5.775? a a) #true)
(check-expect (function=at-1.2-3-and-5.775? add1 sub1) #false)
(define (function=at-1.2-3-and-5.775? f g)
  (and (= (f 1.2) (g 1.2))
       (= (f 3) (g 3))
       (= (f 5.775) (f 5.775))))

;; It is impossible to define a function that checks all numbers, because
;; numbers are infinite.