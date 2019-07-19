;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 175-wc) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
; A List-of-1String is one of:
; - '()
; - (cons 1String List-of-1String)

; A List-of-string is one of:
; - '()
; - (cons String List-of-string)

; A List-of-list-of-string is one of:
; - '()
; - (cons List-of-string List-of-list-of-string)

(define-struct wc [w l])
; A WCcount is a struct:
;  (make-wc 1String Words Lines)
; interpretation counts the number of 1Strings, words, and lines

; LLS -> WCount
; counts words, lines, and 1Strings
(define (wc-util lls w l)
  (cond
    [(empty? lls) (make-wc w l)] ; the entire file is empty, so it's an empty string
    [else
     (wc-util (rest lls)
              (add1 w) ; word count: add 1
              (wc/lines lls l) ; line count: delegate
              )]))

(define (wc/lines lls l)
  (cond
    [(empty? lls) l]
    [else
     (wc/lines (rest lls)
               (add1 l))]))

(define (main n)
  (wc-util (read-words/line
           (string-append n ".txt"))
  0 0))