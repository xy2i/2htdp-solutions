;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 149-copier-works) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N String -> List-of-strings 
; creates a list of n copies of s
 
(check-expect (copier 0 "hello") '())
(check-expect (copier 2 "hello")
              (cons "hello" (cons "hello" '())))
 
(define (copier n s)
  (cond
    [(zero? n) '()]
    [(positive? n) (cons s (copier (sub1 n) s))]))

;; Ex. 149: Does copier function properly when applied to a natural number,
;; a boolean or an image?
; Yes: copier works for any kind of data.
; We would define its signature as:

; N Any -> List-of-Any