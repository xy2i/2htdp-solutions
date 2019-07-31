;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 206-find-association) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/itunes)

; An LLists is one of:
; – '()
; – (cons LAssoc LLists)
 
; An LAssoc is one of: 
; – '()
; – (cons Association LAssoc)
; 
; An Association is a list of two items: 
;   (cons String (cons BSDN '()))
 
; A BSDN is one of: 
; – Boolean
; – Number
; – String
; – Date

(define lassoc1 (list (list "Hello" 1)
                      (list "world" #true)
                      (list "how" 23)))
(define lassoc2 (list (list "How_is_you" 42)
                      (list "secondary_key" (create-date 1 1 1 0 0 0))
                      (list "primary" "this is some really long text")
                      (list "another one" "Hello world!")))
(define lassoc3 (list (list "only one line" 1)))

(define llist1 (list lassoc1 lassoc2 lassoc3))
(define llist2 (list lassoc1 lassoc3 lassoc2 lassoc3 lassoc1))

; String LAssoc Any -> Any
; returns the corresponding item in the lassoc, or default if it is not found
(check-expect (find-association "world" lassoc1 #false)
              (list "world" #true))
(check-expect (find-association "secondary_key" lassoc2 42)
              (list "secondary_key" (create-date 1 1 1 0 0 0)))
(check-expect (find-association "doenst_exist_key" lassoc1 420)
              420)
(define (find-association key lassoc default)
  (cond
    [(empty? lassoc) default]
    [else
     (if (string=? (first (first lassoc)) ; key (left side) of first item
                   key)
         (first lassoc) ; return the assoc
         (find-association key (rest lassoc) default))])) ; keep searching otherwhise