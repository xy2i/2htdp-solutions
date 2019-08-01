;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 210-words-strings) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; List-of-strings -> Boolean
(define (all-words-from-rat? w)
  (and
    (member? "rat" w) (member? "art" w) (member? "tar" w)))
 
; String -> List-of-strings
; finds all words that the letters of some given word spell
 
(check-member-of (alternative-words "cat")
                 (list "act" "cat")
                 (list "cat" "act"))
 
(check-satisfied (alternative-words "rat")
                 all-words-from-rat?)
 
(define (alternative-words s)
  (in-dictionary
    (words->strings (arrangements (string->word s)))))

; A Word is one of:
; - '()
; - (cons 1String Word)

; List-of-words -> List-of-strings
; turns all Words in low into Strings 
(define (words->strings low)
  (cond
    [(empty? low) '()]
    [else (cons (word->string (first low))
           (rest low))]))

     
; Word -> List-of-words
; finds all rearrangements of word
(define (arrangements word)
  (list word))

; String -> Word
; converts s to the chosen word representation 
(define (string->word s) (explode s))
 
; Word -> String
; converts w to a string
(define (word->string w) (implode w))

(require 2htdp/batch-io)
(define LOCATION "/usr/share/dict/words")
(define AS-LIST (read-lines LOCATION))