;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 160-set-add) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Son.L is one of: 
; – empty 
; – (cons Number Son.L)
; 
; Son is used when it 
; applies to Son.L and Son.R
	
; A Son.R is one of: 
; – empty 
; – (cons Number Son.R)
; 
; Constraint If s is a Son.R, 
; no number occurs twice in s

; Son
(define es '())
     
; Number Son -> Boolean
; is x in s
(define (in? x s)
  (member? x s))

; Number Son.L -> Son.L
; adds x in s 
(define s1.L
  (cons 1 '()))
(check-expect
  (set+.L 1 s1.L) (cons 1 s1.L))
(define (set+.L x s)
  (cons x s))
	
; Number Son.R -> Son.R
; adds x in s
(define s1.R
  (cons 1 '()))
(check-expect
  (set+.R 1 s1.R) s1.R)
(check-expect
  (set+.R 2 s1.R) (cons 2 s1.R))
(define (set+.R x s)
  (if (in? x s)
      s
      (cons x s)))