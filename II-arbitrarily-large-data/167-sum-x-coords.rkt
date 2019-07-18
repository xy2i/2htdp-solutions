;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 167-sum-x-coords) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A List-of-posns is one of:
; - '()
; - (cons Posn List-of-posns

; List-of-posns -> Number
; sums all of the posn's X coordinates
(check-expect (sum '()) 0)
(check-expect (sum (cons (make-posn 2 3) '())) 2)
(check-expect
 (sum (cons (make-posn 3 4)
            (cons (make-posn 7 -1) '()))) 10)
(define (sum lop)
  (cond
    [(empty? lop) 0]
    [else
     (+ (posn-x (first lop))
         (sum (rest lop)))]))