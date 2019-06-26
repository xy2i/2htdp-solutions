;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 081-time->seconds) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct time [h m s])
; A Time is a Structure:
; (make-time Number Number Number)

(define t1 (make-time 12 30 30))
(define t2 (make-time 0 20 0))

; Time -> Number
; converts a time to the number of seconds
(check-expect (time->seconds t1) 45030)
(check-expect (time->seconds t2) 1200)
(define (time->seconds t)
  (+
   (* 3600 (time-h t))
   (* 60 (time-m t))
   (time-s t)))