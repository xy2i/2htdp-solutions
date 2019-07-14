;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 147-boolean-nelist) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An NEList-of-booleans is one of: 
; – (cons Boolean '())
; – (cons Boolean NEList-of-booleans)
; interpretation non-empty lists of booleans

; NEList-of-booleans -> Boolean
; checks if at least one boolean in the list is true
(check-expect (one-true (cons #true '())) #true)
(check-expect (one-true (cons #false '())) #false)
(check-expect (one-true (cons #true (cons #true '()))) #true)
(check-expect (one-true (cons #false (cons #true '()))) #true)
(define (one-true ne-l)
  (cond
    [(empty? (rest ne-l)) (first ne-l)]
    ; if #true, there is one boolean, the only boolean in list that is #true
    ; if #false, there is no boolean in the list that's #true
    [else
     (or (first ne-l)
          (one-true (rest ne-l)))]))

; NEList-of-booleans -> Boolean
; checks if all booleans in the list is true
(check-expect (all-true (cons #true '())) #true)
(check-expect (all-true (cons #false '())) #false)
(check-expect (all-true (cons #true (cons #true '()))) #true)
(check-expect (all-true (cons #false (cons #true '()))) #false)
(check-expect (all-true (cons #true (cons #false (cons #true '())))) #false)
(define (all-true ne-l)
  (cond
    [(empty? (rest ne-l)) (first ne-l)]
    ; if #true, all the booleans in the list of one boolean are #true
    ; if #false, there is at least one boolean that's #false
    [else
     (and (first ne-l)
          (all-true (rest ne-l)))]))