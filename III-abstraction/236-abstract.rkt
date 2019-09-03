;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 236-abstract) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Lon -> Lon
; adds 1 to each item on l
(define (add1* l)
  (cond
    [(empty? l) '()]
    [else
     (cons
       (add1 (first l))
       (add1* (rest l)))]))
	
; Lon -> Lon
; adds 5 to each item on l
(define (plus5 l)
  (cond
    [(empty? l) '()]
    [else
     (cons
       (+ (first l) 5)
       (plus5 (rest l)))]))

;; test suite
(check-expect (add1* '(1 2 3)) '(2 3 4))
(check-expect (plus5 '(1 2 3)) '(6 7 8))

;; abstract function
(define (add-x* n l)
  (cond
    [(empty? l) '()]
    [else
     (cons
      (+ (first l) n)
      (add-x* n (rest l)))]))

;; test suite, pass2 
(check-expect (add-x* 1 '(1 2 3)) '(2 3 4))
(check-expect (add-x* 5 '(1 2 3)) '(6 7 8))

;; substraction function
(check-expect (sub2* '(1 2 3)) '(-1 0 1))
(define (sub2* l)
  (add-x* -2 l))