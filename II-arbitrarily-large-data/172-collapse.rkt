;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 172-collapse) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
; A List-of-string is one of:
; - '()
; - (cons String List-of-string)

; A List-of-list-of-string is one of:
; - '()
; - (cons List-of-string List-of-list-of-string)

; LLS -> String
; appends a LLS into a single string
(define (collapse lls)
  (cond
    [(empty? lls) ""] ; the entire file is empty, so it's an empty string
    [else
     (string-append (collapse/line (first lls))
                    ; (first lls) : a List-of-string
                    ; (collapse/line (first lls)): a String
                    (collapse (rest lls)))]))

; List-of-string -> String
; appends a list-of-string into a single string
(define (collapse/line los)
  (cond
    [(empty? los) "\n"] ; if the line is empty, append a newline (go to next line)
    [else
     (string-append (first los) ; a String
                    " " ; separate with whitespace
                    (collapse/line (rest los)))]))

(write-file "ttt.dat"
            (collapse (read-words/line "ttt.txt")))