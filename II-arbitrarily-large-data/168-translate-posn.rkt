;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 168-translate-posn) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A List-of-posns is one of:
; - '()
; - (cons Posn List-of-posns

; List-of-posns -> List-of-posns
; moves all posns 1 unit forward
(check-expect (translate '()) '())
(check-expect (translate (cons (make-posn 2 3) '()))
              (cons (make-posn 2 4) '()))
(check-expect
 (translate (cons (make-posn 3 4)
                  (cons (make-posn 7 -1) '())))
 (cons (make-posn 3 5) (cons (make-posn 7 0) '())))

(define (translate lop)
  (cond
    [(empty? lop) '()]
    [else
     (cons (translate-posn (first lop))
           (translate (rest lop)))]))

; Posn -> Posn
; moves a single posn 1 unit forward on Y
(define (translate-posn p)
  (make-posn (posn-x p)
             (add1 (posn-y p))))