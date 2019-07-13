;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 140-all-true) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A List-of-bools is one of:
; - '()
; - (cons Boolean List-of-bools)

; List-of-bools -> Boolean
; check if the list is full of booleans
(check-expect (all-true '()) #true)
(check-expect (all-true (cons #true '())) #true)
(check-expect (all-true (cons #false '())) #false)
(check-expect (all-true (cons #true (cons #false '()))) #false)
(check-expect (all-true (cons #true (cons #true '()))) #true)

(define (all-true l)
  (cond
    [(empty? l) #true]
    [(cons? l)
     (and (first l)
          (all-true (rest l)))]))

(all-true  (cons #true (cons #false '())))