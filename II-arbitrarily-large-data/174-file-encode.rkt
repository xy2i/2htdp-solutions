;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 174-file-encode) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; LLS -> String
; appends a LLS into a single encoded LLS of strngs
(define (encode lls)
  (cond
    [(empty? lls) ""] ; the entire file is empty, so it's an empty string
    [else
     (string-append (encode/line (first lls))
                    ; (first lls) : a List-of-string
                    ; (encode/line (first lls)): a String
                    (encode (rest lls)))]))

; List-of-String -> String
; appends a LOS into an encoded LOS 
(define (encode/line los)
  (cond
    [(empty? los) "\n"] ; line is empty, go to new line
    [else
     (string-append (encode/word
                     (explode (first los))) ; transform into List-of-1String for further process
                    "; "
                    (encode/line (rest los)))]))

; List-of-1String -> String
; encodes each character of a string
(define (encode/word l1s)
  (cond
    [(empty? l1s) ""] ; nothing to encode
    [else
     (string-append (encode-letter (first l1s))
                    " "
                    (encode/word (rest l1s)))]))


; 1String -> String
; converts the given 1String to a 3-letter numeric String
 
(check-expect (encode-letter "z") (code1 "z"))
(check-expect (encode-letter "\t")
              (string-append "00" (code1 "\t")))
(check-expect (encode-letter "a")
              (string-append "0" (code1 "a")))
 
(define (encode-letter s)
  (cond
    [(>= (string->int s) 100) (code1 s)]
    [(< (string->int s) 10)
     (string-append "00" (code1 s))]
    [(< (string->int s) 100)
     (string-append "0" (code1 s))]))
 
; 1String -> String
; converts the given 1String into a String
 
(check-expect (code1 "z") "122")
 
(define (code1 c)
  (number->string (string->int c)))

(define (main n)
  (write-file (string-append "encoded-" n ".txt")
              (encode (read-words/line
                       (string-append n ".txt")))))