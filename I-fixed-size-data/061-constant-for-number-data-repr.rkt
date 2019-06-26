;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 061-constant-for-number-data-repr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define RED "red")
(define GREEN "green")
(define YELLOW "yellow")
; An S-TrafficLight is one of:
; – RED
; – GREEN
; – YELLOW

; TrafficLight -> TrafficLight
; yields the next state, given current state cs
(check-expect (tl-next-numeric RED) GREEN)
(check-expect (tl-next-numeric GREEN) YELLOW)
(check-expect (tl-next-numeric YELLOW) RED)
(check-expect (tl-next-symbolic RED) GREEN)
(check-expect (tl-next-symbolic GREEN) YELLOW)
(check-expect (tl-next-symbolic YELLOW) RED)

; N-TrafficLight -> N-TrafficLight
; yields the next state, given current state cs
(define (tl-next-numeric cs) (modulo (+ cs 1) 3))

(define (tl-next-symbolic cs)
  (cond
    [(equal? cs RED) GREEN]
    [(equal? cs GREEN) YELLOW]
    [(equal? cs YELLOW) RED]))

;; Ex. 61: Which function is properly designed?
; tl-next-symbolic follows the recipe for itemization:
; its template follows the organization of each sub-class.
; There is a cond clause for each item.
;  If we change the data definition, tl-next-symbolic keeps working.