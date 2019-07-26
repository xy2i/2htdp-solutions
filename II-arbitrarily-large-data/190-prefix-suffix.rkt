;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 190-prefix-suffix) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; List-of-1String -> List-of-List-of-1String
; creates the list of all prefixes
(check-expect (prefixes (list "a" "b" "c" "d"))
              (list (list "a" "b" "c" "d")
                    (list "a" "b" "c")
                    (list "a" "b")
                    (list "a")))
(define (prefixes l1s)
  (cond
    [(empty? l1s) '()]
    [else
     (cons l1s
           (prefixes (list-without-last l1s)))]))

; List-of-1String -> List-of-1String
; returns a list without the last element
(define (list-without-last l1s)
  (cond
    [(empty? (rest l1s)) '()] ; don't consume the last element
    [else
     (cons (first l1s)
           (list-without-last (rest l1s)))]))


; List-of-1String -> List-of-List-of-1String
; creates the list of all suffixes
(check-expect (suffixes (list "a" "b" "c" "d"))
              (list (list "a" "b" "c" "d")
                    (list "b" "c" "d")
                    (list "c" "d")
                    (list "d")))
(define (suffixes l1s)
  (cond
    [(empty? l1s) '()]
    [else
     (cons l1s
           (suffixes (rest l1s)))]))