;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 139-pos) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; A List-of-numbers is one of: 
; – '()
; – (cons Number List-of-numbers)

; List-of-amounts -> Boolean
; check if the list contains positive numbers
(check-expect (pos? '()) #true)
(check-expect (pos? (cons 1 '())) #true)
(check-expect (pos? (cons 2 (cons -1 '()))) #false)
(define (pos? list)
  (cond
    [(empty? list) #true]
    [(cons? list)
     (and (>= (first list) 0)
         (pos? (rest list)))]))

; List-of-amounts -> PositiveNumber
; calculates the sum of all numbers in list if they are positive
(check-expect (checked-sum (cons 1 '())) (sum (cons 1 '())))
(check-error (checked-sum (cons -1 '())) "checked-sum: list must have positive numbers")
(define (checked-sum l)
  (cond
    [(pos? l) (sum l)]
    [else (error "checked-sum: list must have positive numbers")]))