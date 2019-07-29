;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 198-words-by-first-letter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define DICT (list "as" "go" "re" "reality"))
; Letter Dictionnary -> Number
; counts how many words start with a certain letter
(check-expect (starts-with# "a" DICT) 1)
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


; A Letter-Count is a structure: (make-lcount Letter Number)
; interpretation (make-lcount "a" 123)
;  describes a letter that has appeared 123 times
(define-struct lcount [letter count])

; Dictionnary -> List-of-Letter-Count
; returns the list of all letters and how many appear
(check-expect (count-by-letter/inner (list "a" "g" "r") DICT)
              (list
               (make-lcount "a" 1)
               (make-lcount "g" 1)
               (make-lcount "r" 2)))

; use the definition of LETTERS above
(define (count-by-letter dict)
  (count-by-letter/inner LETTERS dict))

; iterates over each letter with a dict
(define (count-by-letter/inner letters dict)
  (cond
    [(empty? letters) '()]
    [else
     (cons (make-lcount (first letters)
                        (starts-with# (first letters) dict))
           (count-by-letter/inner (rest letters) dict))]))

; List-of-Letter-Count -> List-of-Letter-Count
; sorts a list of Letter-Counts
(define (sort l)
  (cond
    [(empty? l) l]
    [else (insert-lc (first l) (sort (rest l)))]))

(define (insert-lc x l)
  (cond
    [(empty? l) (list x)]
    [else (if (>= (lcount-count x)
                  (lcount-count (first l)))
              (cons x l)
              (cons (first l) (insert-lc x (rest l))))]))

; Letter Dictionnary -> Dictionnary
; adds words beggining with a letter to the dict
(check-expect (starts-with "a" DICT) (list "as"))
(define (starts-with letter dict)
  (cond
    [(empty? dict) '()]
    [else
     (if (string=? (first-letter (first dict))
                   letter)
         (cons (first dict) (starts-with letter (rest dict)))
         (starts-with letter (rest dict)))]))

; Dictionnary -> List-of-Dictionnaries
; creates a dict for each letter
(define (words-by-first-letter dict)
  (words-by-first-letter/i LETTERS dict))
(define (words-by-first-letter/i letters dict)
  (cond
    [(empty? letters) '()]
    [else
     (if (empty? (starts-with (first letters) dict))
         (words-by-first-letter/i (rest letters) dict)        
         (cons (starts-with (first letters) dict)
               (words-by-first-letter/i (rest letters) dict)))]))

; List-of-Dictionnaries -> List-of-Lettercounts
; creates a letter count from each character, out of a list of dictionnaries
(check-expect (letter-count-from-list (words-by-first-letter DICT))
              (list (make-lcount "a" 1)
                    (make-lcount "g" 1)
                    (make-lcount "r" 2)))
              
(define (letter-count-from-list lod)
  (cond
    [(empty? lod) '()]
    [else
     (cons (make-lcount (first-letter (first (first lod))) ; get the first letter from the first word of the dictionnary
                        (length (first lod)))
           (letter-count-from-list (rest lod)))]))

; Dictionnary -> Letter-Count
; gets the most common letter
(define (most-frequent dict)
  (first (sort (count-by-letter dict))))
(define (most-frequent.v2 dict)
  (first (sort (letter-count-from-list (words-by-first-letter dict)))))

(check-expect (most-frequent    AS-LIST)
              (most-frequent.v2 AS-LIST))