;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 166-iterative-paychecks) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct work [employee rate hours])
; A (piece of) Work is a structure: 
;   (make-work String Number Number)
; interpretation (make-work n r h) combines the name 
; with the pay rate r and the number of hours h

; Low (short for list of works) is one of: 
; – '()
; – (cons Work Low)
; interpretation an instance of Low represents the 
; hours worked for a number of employees

(define-struct paycheck [employee amount])
; A Paycheck is a structure:
;  (make-paycheck String Number)
; interpretation (make-paycheck n m) pays
; m to the employee of name n

(check-expect (wage*.v3 '()) '())
(check-expect
  (wage*.v3
    (cons (make-work "Robby" 11.95 39) '()))
  (cons (make-paycheck "Robby" (* 11.95 39)) '()))
(check-expect
 (wage*.v3
  (cons (make-work "Matthew" 12.95 45)
        (cons (make-work "Robby" 11.95 39)
              '())))
  (cons (make-paycheck "Matthew" (* 12.95 45))
        (cons (make-paycheck "Robby" (* 11.95 39)) '())))

(define (wage*.v3 an-low)
  (cond
    [(empty? an-low) '()]
    [(cons? an-low)
     (cons (wage.v3 (first an-low))
           (wage*.v3 (rest an-low)))]))
 
; Work -> Paycheck
; computes the paycheck for the given work record w
(define (wage.v3 w)
  (make-paycheck (work-employee w)
                 (* (work-rate w) (work-hours w))))