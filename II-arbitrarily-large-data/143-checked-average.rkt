;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 143-checked-average) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A List-of-temperatures is one of: 
; – '()
; – (cons CTemperature List-of-temperatures)
 
; A CTemperature is a Number greater than -273.

; List-of-temperatures -> Number
; computes the average temperature
(check-expect
 (average (cons 1 (cons 2 (cons 3 '())))) 2)
(define (average alot)
  (/ (sum alot) (how-many alot)))
 
; List-of-temperatures -> Number 
; adds up the temperatures on the given list
(check-expect
 (sum (cons 1 (cons 2 (cons 3 '())))) 6)
(define (sum alot)
  (cond
    [(empty? alot) 0]
    [else (+ (first alot) (sum (rest alot)))]))
 
; List-of-temperatures -> Number 
; counts the temperatures on the given list
(check-expect
 (how-many (cons 1 (cons 2 (cons 3 '())))) 3)
(define (how-many alot)
  (cond
    [(empty? alot) 0]
    [else (+ (how-many (rest alot)) 1)]))

; List-of-temperatures -> Number
; computes the average temperature, if the list is not empty
(check-error
 (checked-average '()) "checked-average: list cannot be empty")
(check-expect
 (checked-average (cons 1 (cons 2 (cons 3 '())))) 2)
(define (checked-average alot)
  (cond
    [(empty? alot) (error "checked-average: list cannot be empty")]
    [(cons? alot) (average alot)]))

;; Ex. 143: Determine how average behaves in DrRacket when applied to the empty list.
; Both recursions, sum and how-many, have 0 as the base case. This ends up happening:
; (average '())
; ==
; (/ (sum '()) (how-many '())
; ==
; (/ 0 0)
; ==
; error: division by zero