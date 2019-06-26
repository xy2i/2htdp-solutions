;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 060-number-data-repr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
; An N-TrafficLight is one of:
; – 0 interpretation the traffic light shows red
; – 1 interpretation the traffic light shows green
; – 2 interpretation the traffic light shows yellow

(define BULB-SIZE 5)

; String, String -> Image
; draws an one-colored bulb
(check-expect (bulb "solid" "red") (circle 5 "solid" "red"))
(check-expect (bulb "outline" "yellow") (circle 5 "outline" "yellow"))
(check-expect (bulb "solid" "green") (circle 5 "solid" "green"))

(define (bulb fill color)
  (circle BULB-SIZE fill color))

; TrafficLight -> TrafficLight
; yields the next state, given current state cs
(check-expect (tl-next-numeric 0) 1)
(check-expect (tl-next-numeric 1) 2)
(check-expect (tl-next-numeric 2) 0)

; N-TrafficLight -> N-TrafficLight
; yields the next state, given current state cs
(define (tl-next-numeric cs) (modulo (+ cs 1) 3))
 
; TrafficLight -> Image
; renders the current state cs as an image
(check-expect
 (tl-render 0)
  (underlay/xy
   (underlay/xy
    (underlay/xy (empty-scene 50 20) 5 5 (bulb "solid" "red"))
    20 5 (bulb "outline" "yellow"))
   35 5 (bulb "outline" "green")))

(define (tl-render current-state)
  (cond
    [(= 0 current-state)
     (underlay/xy
      (underlay/xy
       (underlay/xy (empty-scene 50 20) 5 5 (bulb "solid" "red"))
       20 5 (bulb "outline" "yellow"))
      35 5 (bulb "outline" "green"))]
    [(= 1 current-state)
     (underlay/xy
      (underlay/xy
       (underlay/xy (empty-scene 50 20) 5 5 (bulb "outline" "red"))
       20 5 (bulb "solid" "yellow"))
      35 5 (bulb "outline" "green"))]
    [(= 2 current-state)
     (underlay/xy
      (underlay/xy
       (underlay/xy (empty-scene 50 20) 5 5 (bulb "outline" "red"))
       20 5 (bulb "outline" "yellow"))
      35 5 (bulb "solid" "green"))]))

; TrafficLight -> TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next-numeric 1]))

;; Ex. 60: Does the tl-next function carry its intention more clearly?
; Yes, because we can clearly see what kind of data is used in tl-next,
; but when we use numbers, the intent is not obvious.