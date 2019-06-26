;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 082-compare-word) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct word [c1 c2 c3])
; A Word is a structure:
;  (make-word 1String 1String 1String)

(define w1 (make-word "a" "b" "c"))
(define w2 (make-word "a" "e" "c"))

; A WordPart is:
; - 1String
; - #false

; 1String 1String -> WordPart
; checks if two 1Strings are the same
(check-expect (compare-letters "c" "c") "c")
(check-expect (compare-letters "c" "f") #false)
(define (compare-letters a b)
  (if (string=? a b) a #false))

; Word Word -> Word
; gives a word indicating where they agree and disagree
(check-expect (compare-word w1 w2)
              (make-word "a" #false "c"))
(define (compare-word wa wb)
  (make-word
   (compare-letters (word-c1 wa) (word-c1 wb))
   (compare-letters (word-c2 wa) (word-c2 wb))
   (compare-letters (word-c3 wa) (word-c3 wb))))