;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 169-legal) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A List-of-posns is one of:
; - '()
; - (cons Posn List-of-posns

; List-of-posns -> List-of-posns
; check if the posn is legal: 0 < x < 100, 0 < y < 200
(check-expect (legal '()) '())
(check-expect (legal (cons (make-posn 2 3) '()))
              (cons (make-posn 2 3) '()))
(check-expect
 (legal (cons (make-posn 3 205)
                  (cons (make-posn 7 -1) '())))
 '())

(define (legal lop)
  (cond
    [(empty? lop) '()]
    [else
     (if (legal? (first lop))
         (cons (first lop) (legal (rest lop)))
         (legal (rest lop)))]))

; Posn -> Boolean
; checks if the posn is legal
(define (legal? p)
  (and (< 0 (posn-x p) 100)
       (< 0 (posn-y p) 200)))