;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 187-sort-gp) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct gp [name score])
; A GamePlayer is a structure: 
;    (make-gp String Number)
; interpretation (make-gp p s) represents player p who 
; scored a maximum of s points

; List-of-GamePlayer -> GamePlayer
; sorts a list of GamePlayers
(check-expect (sort-gp> (list (make-gp "Ascond" 1) (make-gp "Betty" 2)))
              (list (make-gp "Betty" 2) (make-gp "Ascond" 1)))
(define (sort-gp> l)
  (cond
    [(empty? l) '()]
    [else (insert (first l)
                  (sort-gp> (rest l)))]))

; GamePlayer List-of-GamePlayer -> List-of-GamePlayer
; inserts a GamePlayer in a sorted list
(define (insert gp l)
  (cond
    [(empty? l) (cons gp '())]
    [else
     (if (compare>? gp (first l))
      (cons gp l)
      (cons (first l) (insert gp (rest l))))]))

; GamePlayer GamePlayer -> Boolean
; checks if a gameplayer is better than the other
(check-expect (compare>? (make-gp "Ascond" 1) (make-gp "Betty" 2))
              #false)
(define (compare>? gp1 gp2)
  (> (gp-score gp1) (gp-score gp2)))