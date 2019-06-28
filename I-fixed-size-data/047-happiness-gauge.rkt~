;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 047-happiness-gauge) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

; background
(define BACKGROUND (empty-scene 100 20))

; A WorldState is a number.
; interpretation the happiness of the animal

; WorldState -> WorldState
; decreases the happiness level, but cannot go below 0
; given: 40, expect: 39.9
; given: 0.1, expect: 0
; given: 0, expect: 0
(define (tock ws)
  (cond
    [(> ws 0) (- ws 0.1)]
    [else ws]))

(check-expect (tock 40) 39.9)
(check-expect (tock 0.1) 0)
(check-expect (tock 0) 0)

; WorldState -> WorldState
; increases the happiness level based on the pressed key
(define (increase-happiness ws ke)
  (cond
    [(key=? ke "down") (+ ws (/ ws 5))]
    [(key=? ke "up") (+ ws (/ ws 3))]
    [else ws]))

(check-expect (increase-happiness 50 "down") 60)
(check-expect (increase-happiness 30 "up") 40)

; WorldState -> Image
; renders the happiness gauge
(define (render ws)
  (overlay/align "left" "middle"
                 (rectangle ws 20 "solid" "green")
                 BACKGROUND))

; WorldState -> WorldState
; launches the program from some initial state 
(define (gauge-prog ws)
   (big-bang 100
     [on-tick tock]
     [on-key increase-happiness]
     [to-draw render]))