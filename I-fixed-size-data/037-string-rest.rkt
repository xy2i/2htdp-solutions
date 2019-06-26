;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 037-string-rest) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; String -> String
; removes the first letter of the string
; given: "hello", expect: "ello"
; given: "world", expect: "orld"
(define (string-rest str)
  (substring str
             1
             (string-length str))) ; substring is exclusive on the outer bound