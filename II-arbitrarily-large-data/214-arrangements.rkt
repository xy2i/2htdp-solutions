;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 214-arrangements) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(define LOCATION "/usr/share/dict/words")
 ; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))

; List-of-strings -> Boolean

;; NOTE FROM AUTHOR: I have a French dictionary on my system, so my examples may be different
;; and not work on your machine. Adjust accordingly.
(define (all-words-from-rat? w)
  (and
   (member? "rat" w) (member? "art" w)))
 
; String -> List-of-strings
; finds all words that the letters of some given word spell
(check-satisfied (alternative-words "rat")
                 all-words-from-rat?)
 
(define (alternative-words s)
  (in-dictionary
   (words->strings (arrangements (string->word s)))))

; A Word is one of:
; – '() or
; – (cons 1String Word)
; interpretation a Word is a list of 1Strings (letters)

; A List-of-Words is one of:
; - '()
; - (cons Word List-of-Words)

(define word1 (list "h" "i"))
(define word2 (list "w" "o" "r" "l" "d"))
(define word3 (list "c" "r" "i" "k" "e" "y"))
(define lword1 (list word1 word2 word3))

; List-of-words -> List-of-strings
; turns all Words in low into Strings 
(define (words->strings low)
  (cond
    [(empty? low) '()]
    [else (cons (word->string (first low))
                (words->strings (rest low)))]))

; List-of-strings -> List-of-strings
; picks out all those Strings that occur in the dictionary 
(define (in-dictionary los)
  (cond
    [(empty? los) '()]
    [else
     (if (word-in-dict? (first los) AS-LIST)
         (cons (first los) (in-dictionary (rest los)))
         (in-dictionary (rest los)))]))

(check-expect (word-in-dict? "bonjour" (list "ok" "bonjour")) #true)
(define (word-in-dict? word dict)
  (cond
    [(empty? dict) #false]
    [else
     (or (string=? word (first dict)) (word-in-dict? word (rest dict)))]))
     
; Word -> List-of-words
; creates all rearrangements of the letters in w
(check-expect (arrangements word1)
              (list (list "h" "i")
                    (list "i" "h")))
(define (arrangements w)
  (cond
    [(empty? w) (list '())]
    [else (insert-everywhere/in-all-words (first w)
                                          (arrangements (rest w)))]))

; 1String List-of-words -> List-of-words
; creates a list of words with the 1String at start
(check-expect (insert-everywhere/in-all-words "a" (list (list "s")))
              (list (list "a" "s")
                    (list "s" "a")))
(check-expect (insert-everywhere/in-all-words "a" (list (list "e" "r")
                                                        (list "r" "e")))
                                              (list
                                               (list "a" "e" "r")
                                               (list "e" "a" "r")
                                               (list "e" "r" "a")
                                               (list "a" "r" "e")
                                               (list "r" "a" "e")
                                               (list "r" "e" "a")))
(define (insert-everywhere/in-all-words 1s low)
  (cond
    [(empty? low) '()]
    [else (append (insert-everywhere/single 1s '() (first low))
                  (insert-everywhere/in-all-words 1s (rest low)))]))

; 1String Word Word -> List-of-words
; inserts in a single word at all places
(check-expect (insert-everywhere/single "a" '() (list "h" "i"))
              (list
               (list "a" "h" "i")
               (list "h" "a" "i")
               (list "h" "i" "a")))
(define (insert-everywhere/single 1s pre post)
  (cond
    [(empty? post) (cons (insert/single 1s pre post) '())]
    [else (cons (insert/single 1s pre post)
                (insert-everywhere/single 1s
                                          (append pre (list (first post)))
                                          (rest post)))]))
; 1String Word Word -> Word
; inserts in a single word at a place
(check-expect (insert/single "a" (list "h" "i") (list "b"))
              (list "h" "i" "a" "b")) 
(define (insert/single 1s pre post)
  (append (append pre (list 1s)) post))
  
; String -> Word
; converts s to the chosen word representation 
(define (string->word s) (explode s))
 
; Word -> String
; converts w to a string
(define (word->string w) (implode w))