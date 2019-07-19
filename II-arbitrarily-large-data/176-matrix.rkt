;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 176-matrix) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Matrix is one of: 
;  – (cons Row '())
;  – (cons Row Matrix)
; constraint all rows in matrix are of the same length
 
; A Row is one of: 
;  – '() 
;  – (cons Number Row)

(define mat (cons (cons 11 (cons 12 '()))
                  (cons (cons 21 (cons 22 '()))
                        '())))

; transposed
(define tam (cons (cons 11 (cons 21 '()))
                  (cons (cons 12 (cons 22 '()))
                        '())))

; Matrix -> Matrix
; transposes the given matrix along the diagonal 
(check-expect (transpose mat) tam)
(define (transpose lln)
  (cond
    [(empty? (first lln)) '()]
    [else (cons (first* lln) (transpose (rest* lln)))]))

; Matrix -> List-of-numbers
; creates a row from the first column of a matrix
(check-expect (first* mat) (cons 11 (cons 21 '())))
(define (first* mat)
  (cond
    [(empty? mat) '()] ; end of the matrix
    [else
     (cons (first (first mat)) ; get the first element of the row, as in an element of the first column
           (first* (rest mat)))]))

; Matrix -> Lon
; removes the first column from a matrix
(define (rest* mat)
  (cond
    [(empty? mat) '()]
    [else
     (cons (rest (first mat)) ; gets the remaining elements of the row, as in the elements of the remaining columns
           (rest* (rest mat)))]))