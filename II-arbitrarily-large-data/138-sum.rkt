;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 138-sum) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A List-of-amounts is one of: 
; – '()
; – (cons PositiveNumber List-of-amounts)

; List-of-amounts -> PositiveNumber
; calculates the sum of all accounts
(check-expect (sum '()) 0)
(check-expect (sum (cons 1 '())) 1)
(check-expect (sum (cons 2 (cons 3 '()))) 5)
(define (sum list)
  (cond
    [(empty? list) 0]
    [(cons? list)
     (+ (first list)
        (sum (rest list)))]))