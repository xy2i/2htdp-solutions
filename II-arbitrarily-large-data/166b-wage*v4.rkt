;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 166b-wage*v4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct info [id name])
; An Info is a struct:
;  (make-info Number String)
; interpretation (make-info i n)
; creates an employee record with name n and id i

(define-struct work [info rate hours])
; A (piece of) Work is a structure: 
;   (make-work String Number Number Number)
; interpretation (make-work i r h) combines the info i
; with the pay rate r and the number of hours h

; Low (short for list of works) is one of: 
; – '()
; – (cons Work Low)
; interpretation an instance of Low represents the 
; hours worked for a number of employees

(define-struct paycheck [id employee amount])
; A Paycheck is a structure:
;  (make-paycheck Id String Number)
; interpretation (make-paycheck id n m) pays
; m to the employee of name n with id id

(check-expect (wage*.v4 '()) '())
(check-expect
  (wage*.v4
    (cons (make-work (make-info 1 "Robby") 11.95 39) '()))
  (cons (make-paycheck 1 "Robby" (* 11.95 39)) '()))
(check-expect
 (wage*.v4
  (cons (make-work (make-info 2 "Matthew") 12.95 45)
        (cons (make-work (make-info 1 "Robby") 11.95 39)
              '())))
  (cons (make-paycheck 2 "Matthew" (* 12.95 45))
        (cons (make-paycheck 1 "Robby" (* 11.95 39)) '())))

(define (wage*.v4 an-low)
  (cond
    [(empty? an-low) '()]
    [(cons? an-low)
     (cons (wage.v4 (first an-low))
           (wage*.v4 (rest an-low)))]))
 
; Work -> Paycheck
; computes the paycheck for the given work record w
(define (wage.v4 w)
  (make-paycheck (info-id (work-info w))
                 (info-name (work-info w))
                 (* (work-rate w) (work-hours w))))