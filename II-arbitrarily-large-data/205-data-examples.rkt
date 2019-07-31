;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 205-data-examples) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/itunes)

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