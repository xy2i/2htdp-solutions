;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 163-convertFC) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Number -> Number
; converts to a Fahrenheit temperature
(define (C f)
  (* 5/9 (- f 32)))

; List-of-numbers -> List-of-numbers
; convers a list to Fahrenheit temperatures
(check-expect (convertFC (cons 5 (cons 5 '())))
              (cons -15 (cons -15 '())))
(define (convertFC l)
  (cond
    [(empty? l) '()]
    [else
     (cons (C (first l)) (convertFC (rest l)))]))