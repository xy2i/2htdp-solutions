;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 058-tax-land) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Price falls into one of three intervals: 
; — 0 through 1000 excluded
; — 1000 through 10000 excluded
; — 10000 and above.
; interpretation the price of an item

(define low-price 1000)
(define luxury-price 10000)

; Price -> Number
; computes the amount of tax charged for p
(check-expect (sales-tax 0) 0)
(check-expect (sales-tax 537) 0)
(check-expect (sales-tax 1000) (* 0.05 1000))
(check-expect (sales-tax 1282) (* 0.05 1282))
(check-expect (sales-tax 10000) (* 0.08 10000))
(check-expect (sales-tax 12017) (* 0.08 12017))

(define (sales-tax p)
  (cond
    [(and (<= 0 p) (< p low-price)) 0]
    [(and (<= low-price p) (< p luxury-price)) (* 0.05 p)]
    [(>= p luxury-price) (* 0.08 p)]))