;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 051-big-bang-traffic) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume

; TrafficLight -> TrafficLight
; yields the next state given current state s
(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "yellow") "red")
(check-expect (traffic-light-next "green") "yellow")
(define (traffic-light-next s)
  (cond
    [(string=? "red" s) "green"]
    [(string=? "green" s) "yellow"]
    [(string=? "yellow" s) "red"]))

; TrafficLight -> TrafficLight
; gives the next traffic light
(define (tock traffic-light)
  (traffic-light-next traffic-light))

; TrafficLight -> Image
; displays the current traffic light
(define (render traffic-light)
  (circle 100 "solid" traffic-light))

; TrafficLight -> TrafficLight
; launches the program from some initial state 
(define (traffic-light ws)
   (big-bang ws
     [on-tick tock]
     [to-draw render]))

(traffic-light "red")