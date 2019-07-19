;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 175-wc) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
; A List-of-string is one of:
; - '()
; - (cons String List-of-string)

; A List-of-list-of-string is one of:
; - '()
; - (cons List-of-string List-of-list-of-string)

(define-struct wc [l w c])
; A WCcount is a struct:
;  (make-wc lines words 1strings)
; interpretation counts the number of 1strings, words, and lines

; LLS -> WCount
; counts words, lines, and 1Strings
(define (wc-util lls)
  (make-wc
   (count-lines lls)
   (count-words lls)
   (count-1string lls)))

; LLS -> Number
; counts lines
(check-expect (count-lines (cons '()
                                 (cons (cons "a" (cons "b" (cons "c" '())))
                                       (cons (cons "how" '()) '()))))
              3)
(define (count-lines lls)
  (length lls))

; LLS -> Number
; counts words
(check-expect (count-words (cons '()
                                 (cons (cons "a" (cons "b" (cons "c" '())))
                                       (cons (cons "how" '()) '()))))
              4)
(define (count-words lls)
  (cond
    [(empty? lls) 0]
    [else (+ (count-words/line (first lls))
             (count-words (rest lls)))]))

(define (count-words/line los)
  (length los))

; LLS -> Number
; counts 1String on the entire list
(check-expect (count-1string (cons '()
                                 (cons (cons "a" (cons "b" (cons "c" '())))
                                       (cons (cons "how" '()) '()))))
              6)
(define (count-1string lls)
  (cond
    [(empty? lls) 0]
    [else (+ (count-1string/line (first lls))
             (count-1string (rest lls)))]))

(define (count-1string/line los)
  (cond
    [(empty? los) 0]
    [else (+ (count-1string/word (first los))
             (count-1string/line (rest los)))]))

(define (count-1string/word s)
  (string-length s))

(define (main n)
  (wc-util (read-words/line
            (string-append n ".txt"))))