;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 238-inf) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Nelon -> Number
; determines the smallest 
; number on l
(define (inf l)
  (cond
    [(empty? (rest l))
     (first l)]
    [else
     (if (< (first l)
            (inf (rest l)))
         (first l)
         (inf (rest l)))]))
	
; Nelon -> Number
; determines the largest 
; number on l
(define (sup l)
  (cond
    [(empty? (rest l))
     (first l)]
    [else
     (if (> (first l)
            (sup (rest l)))
         (first l)
         (sup (rest l)))]))

; [Any Any->Boolean] List-of-any -> Number
; determines an element of l that best satisfies
; a property (two arg func to infinite arg func)
(define (compare F l)
  (cond
    [(empty? (rest l))
     (first l)]
    [else
     (if (F (first l)
            (compare F (rest l)))
         (first l)
         (compare F (rest l)))]))

(define (inf-1 l)
  (compare < l))

(define (sup-1 l)
  (compare > l))
(define (inf-2 l)
  (compare min l))
(define (sup-2 l)
  (compare max l))

; Recurs