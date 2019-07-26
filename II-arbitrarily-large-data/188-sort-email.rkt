;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 188-sort-email) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct email [from date message])
; An Email Message is a structure: 
;   (make-email String Number String)
; interpretation (make-email f d m) represents text m 
; sent by f, d seconds after the beginning of time

; A List-of-Email is one of:
; - '()
; - (cons Email List-of-Email)

(define A (make-email "Alice" 3 "Hello Bob!"))
(define B (make-email "Bob" 2 "Hello Alice!"))
(define C (make-email "Charlie" 3 "Hello Bob!"))

; List-of-Email -> List-of-Email
; sorts a list of emails, in alphabetic order
(check-expect (sort-alph
               (list B A))
              (list A B))

(define (sort-alph l)
  (cond
    [(empty? l) '()]
    [else
     (insert (first l) (sort-alph (rest l)))]))

; Email List-of-Email -> List-of-Email
; inserts an email in an alphabetically sorted list of emails
(check-expect (insert B (list A C))
              (list A B C))

(define (insert e l)
  (cond
    [(empty? l) (cons e l)]
    [else
     (if (compare-lex<? e (first l))
         (cons e l)
         (cons (first l) (insert e (rest l))))]))

; Email Email -> Boolean
; checks if the first email is less than the second,
; according to alphabetical order
(check-expect (compare-lex<? A B) #true)
(check-expect (compare-lex<? C B) #false)
(define (compare-lex<? e1 e2)
  (string<? (email-from e1) (email-from e2)))