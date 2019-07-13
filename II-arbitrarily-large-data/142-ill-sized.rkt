;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 142-ill-sized) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
; A List-of-images is one of:
; - '()
; - (cons Image List-of-images)

; ImageOrFalse is one of:
; – Image
; – #false

(check-expect (ill-sized? '())
              #false)
(check-expect (ill-sized? (cons (square 10 "solid" "red") '()))
              #false)
(check-expect (ill-sized? (cons (rectangle 5 10 "solid" "blue") '()))
              (rectangle 5 10 "solid" "blue"))
(check-expect (ill-sized? (cons (square 10 "solid" "red") (cons (rectangle 5 10 "solid" "blue") '())))
              (rectangle 5 10 "solid" "blue"))
(check-expect (ill-sized? (cons (square 10 "solid" "red") (cons (square 10 "outline" "red") '())))
              #false)

; List-of-images -> ImageOrFalse
; returns the first image that is NOT a square, or #false if none are found
(define (ill-sized? l)
  (cond
    [(empty? l) #false]
    [(cons? l)
     (if (image-square? (first l)) ; it is a square, so does not match our definition
         (ill-sized? (rest l))
         (first l))])) ; it's something else, stop here