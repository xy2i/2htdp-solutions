;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 164-convert-euro) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Number -> Number
; converts a dollar amount to euros
(define (convert d r)
  (* r d))

; List-of-numbers -> List-of-numbers
; convers a list of dollar amounts to a list of euros
(check-expect (convert-euro* (cons 1 (cons 2 '())) 0.89)
              (cons 0.89 (cons 1.78 '())))
(check-expect (convert-euro* (cons 1 (cons 2 '())) 0.25)
              (cons 0.25 (cons 0.5 '())))
(define (convert-euro* l r)
  (cond
    [(empty? l) '()]
    [else
     (cons (convert (first l) r) (convert-euro* (rest l) r))]))