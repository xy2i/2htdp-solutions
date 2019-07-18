;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 170-replace-phone) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct phone [area switch four])
; A Phone is a structure: 
;   (make-phone Three Three Four)
; A Three is a Number between 100 and 999. 
; A Four is a Number between 1000 and 9999.

; A Lop (list-of-phones) is one of:
; - '()
; - (cons Phone Lop)

; Lop -> Lop
; replaces all occurences of area code 713 with 281
(check-expect (replace '()) '())
(check-expect (replace (cons (make-phone 713 293 1293) '()))
              (cons (make-phone 281 293 1293) '()))
(check-expect (replace (cons (make-phone 713 293 1293)
                             (cons (make-phone 123 456 7890) '())))
              (cons (make-phone 281 293 1293)
                    (cons (make-phone 123 456 7890) '())))
(define (replace lop)
  (cond
    [(empty? lop) '()]
    [else
     (cons (replace-phone (first lop))
           (replace (rest lop)))]))

; Phone -> Phone
; changes the phone if area code 713, to 281
(define (replace-phone p)
  (cond
    [(= (phone-area p) 713)
     (make-phone
      281
      (phone-switch p)
      (phone-four p))]
    [else p]))