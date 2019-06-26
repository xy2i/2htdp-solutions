;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 035-string-last) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; String -> 1String
; takes the last 1String from a non-empty str
; if str is empty, takes an empty string
; given: "hello", expect: "o"
; given: "world", expect: "d"
; given: "", expect: ""
(define (string-last str)
  (if (= (string-length str) 0)
      ""
      (string-ith str
                  (- (string-length str) 1))))