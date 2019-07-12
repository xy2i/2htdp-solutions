;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 113-more-predicates) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])

(define (sigs? v)
  (cond
    [(or (aim? v) (fired? v)) #true]
    [else #false]))

(define ex1 -10)
(define ex2 -40)
(define ex3 10)
(define ex4 80)
(define ex5 (make-posn 10 10))
(define ex6 (make-posn -20 -20))

(define (coord? v)
  (cond
    [(number? v) #true] ; accounts for positive and negative
    [(posn? v) #true]
    [else #false]))

(define-struct vcat [x hv])
(define-struct vcham [x hv])

(define (va? v)
  (cond
    [(or (vcat? v) (vcham? v)) #true]
    [else #false]))