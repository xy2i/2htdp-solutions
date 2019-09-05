;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 242-maybe) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A [Maybe X] is one of: 
; – #false 
; – X

; A [Maybe String] is one of:
; - #false
; - String

; A [Maybe [List-of String]] is one of:
; - #false
; - [List-of String]

; A [List-of [Maybe String]] is one of:
; - '()
; - (cons [Maybe String] [List-of [Maybe String]])


;; Returns #false if there's nothing or a String.

; String [List-of String] -> [Maybe [List-of String]]
; returns the remainder of los starting with s 
; #false otherwise 
(check-expect (occurs "a" (list "b" "a" "d" "e"))
              (list "d" "e"))
(check-expect (occurs "a" (list "b" "c" "d")) #f)
(define (occurs s los)
  (cond
    [(empty? los) #false] ; nothing found : list is empty
    [else
     (if (string=? s (first los)) ; first are equal?
         (rest los) ; return the rest : without the first character, the remainder
         (occurs s (rest los)))])) ; keep searching