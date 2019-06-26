;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 059-fsm-traffic) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume
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
(check-expect (tl-next "red") "green")
(check-expect (tl-next "yellow") "red")
(check-expect (tl-next "green") "yellow")

(define (tl-next cs)
  (cond
    [(string=? "red" cs) "green"]
    [(string=? "green" cs) "yellow"]
    [(string=? "yellow" cs) "red"]))
 
; TrafficLight -> Image
; renders the current state cs as an image
(check-expect
 (tl-render "red")
  (underlay/xy
   (underlay/xy
    (underlay/xy (empty-scene 50 20) 5 5 (bulb "solid" "red"))
    20 5 (bulb "outline" "yellow"))
   35 5 (bulb "outline" "green")))

(define (tl-render current-state)
  (cond
    [(string=? "red" current-state)
     (underlay/xy
      (underlay/xy
       (underlay/xy (empty-scene 50 20) 5 5 (bulb "solid" "red"))
       20 5 (bulb "outline" "yellow"))
      35 5 (bulb "outline" "green"))]
    [(string=? "yellow" current-state)
     (underlay/xy
      (underlay/xy
       (underlay/xy (empty-scene 50 20) 5 5 (bulb "outline" "red"))
       20 5 (bulb "solid" "yellow"))
      35 5 (bulb "outline" "green"))]
    [(string=? "green" current-state)
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
    [on-tick tl-next 1]))