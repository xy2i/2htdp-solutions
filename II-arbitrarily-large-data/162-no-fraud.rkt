;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 162-no-fraud) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define WAGE 14)

; Number -> Number
; computes the wage for h hours of work
(define (wage h)
  (* WAGE h))

; List-of-numbers -> List-of-numbers
; computes the weekly wages for the weekly hours
(check-expect (wage* '()) '())
(check-expect (wage* (cons 28 '())) (cons (wage 28) '()))
(check-expect (wage* (cons 4 (cons 2 '()))) (cons (wage 4) (cons (wage 2) '())))
(check-error (wage* (cons 1200 '())) "fraud is bad")
(define (wage* whrs)
  (if (whrs-fraud? whrs)
      (error "fraud is bad")
      (cond
        [(empty? whrs) '()]
        [else (cons
               (wage (first whrs))
               (wage* (rest whrs)))])))

; List-of-numbers -> Boolean
; determines if there's fraud for this list
(define (whrs-fraud? whrs)
  (cond
    [(empty? whrs) #false]
    [else
     (or (> (first whrs) 100)
         (whrs-fraud? (rest whrs)))]))