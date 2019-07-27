;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 195-starts-with) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))

; On OS X: 
(define LOCATION "/usr/share/dict/words")
; On LINUX: /usr/share/dict/words or /var/lib/dict/words
; On WINDOWS: borrow the word file from your Linux friend
 
; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))

; Letter Dictionnary -> Number
; counts how many words start with a certain letter
(check-expect (starts-with# "a" (list "as" "go" "re")) 1)
(define (starts-with# letter dict)
  (cond
    [(empty? dict) 0]
    [else
     (if (string=? (first-letter (first dict))
                   letter)
         (add1 (starts-with# letter (rest dict)))
         (starts-with# letter (rest dict)))]))

; String -> String
; gets the first letter of a string
(define (first-letter string)
  (string-ith string 0))

(starts-with# "e" AS-LIST)
(starts-with# "z" AS-LIST)