;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 165-substitute) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; List-of-strings -> List-of-strings
; replaces "robot" with "r2d2"
(check-expect (subst-robot (cons "robot" (cons "toy" '())))
              (cons "r2d2" (cons "toy" '())))
(define (subst-robot l)
  (cond
    [(empty? l) '()]
    [else (cons
           (sub (first l))
           (subst-robot (rest l)))]))

(define (sub s)
  (if
    (string=? "robot" s)
    "r2d2"
    s))

; Generalise to substitute
(check-expect (substitute (cons "robot" (cons "toy" '())) "r2d2" "robot")
              (cons "r2d2" (cons "toy" '())))
(define (substitute l new old)
  (cond
    [(empty? l) '()]
    [else (cons
           (subg (first l) new old)
           (substitute (rest l) new old))]))

(define (subg s new old)
  (if
    (string=? s old)
    new
    s))