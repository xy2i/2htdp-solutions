;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 105-coordinates) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
; A Coordinate is one of: 
; – a NegativeNumber 
; interpretation on the y axis, distance from top
; – a PositiveNumber 
; interpretation on the x axis, distance from left
; – a Posn
; interpretation an ordinary Cartesian point
(define BG (scene+line (scene+line (empty-scene 100 100) 50 0 50 100 "black" ) 0 50 100 50 "black"))
(define point (circle 4 "solid" "red"))
(define ex1 -10)
(define ex2 -40)
(define dx1 (place-image point 50 (- ex1) BG))
(define dx2 (place-image point 50 (- ex2) BG))

(define ex3 10)
(define ex4 80)
(define dx3 (place-image point ex3 50 BG))
(define dx4 (place-image point ex4 50 BG))

(define ex5 (make-posn 10 10))
(define ex6 (make-posn -20 -20))
(define dx5 (place-image point (+ 50 (posn-x ex5))
                         (- 50 (posn-y ex5)) BG))
(define dx6 (place-image point (+ 50 (posn-x ex6))
                         (- 50 (posn-y ex6)) BG))
dx1
dx2
dx3
dx4
dx5
dx6