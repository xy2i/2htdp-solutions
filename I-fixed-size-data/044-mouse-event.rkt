;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 044-mouse-event) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH-OF-WORLD 200)
     
(define WHEEL-RADIUS 12)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))

(define WHEEL
  (circle WHEEL-RADIUS "solid" "black"))

(define SPACE
  (rectangle (* 2 WHEEL-RADIUS) 0 "solid" "white"))
(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL))
(define HEIGHT-LOWER (* 2 WHEEL-RADIUS))
(define HEIGHT-UPPER (* 3 WHEEL-RADIUS))

(define WIDTH-UPPER (* 4 WHEEL-RADIUS))

(define LOWER ; lower part of car
  (rectangle (* 2 WIDTH-UPPER) HEIGHT-LOWER "solid" "red"))
(define UPPER ; upper part of car
  (rectangle WIDTH-UPPER HEIGHT-UPPER "solid" "red"))
(define BOTH ; compose both parts
  (overlay/align "middle" "bottom" UPPER LOWER))

; an exact height places the wheels exactly over
; we need to go back a bit, with substraction
; circles have their middle in their center
(define SPACE-WHEEL-CAR (- (image-height BOTH) WHEEL-RADIUS))

(define CAR
  (underlay/xy BOTH WHEEL-RADIUS
               SPACE-WHEEL-CAR BOTH-WHEELS))

; background
(define tree
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))
(define scene
  (empty-scene 400 (image-height CAR)))
(define BACKGROUND
  (underlay/xy scene 40 0 tree))

; an image is always placed by its center
(define Y-CAR (/ (image-height CAR) 2))

; WorldState -> WorldState 
; moves the car by 3 pixels for every clock tick
; examples: 
;   given: 20, expect 23
;   given: 78, expect 81
(define (tock ws)
  (+ ws 3))
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)

; WorldState -> Image
; places the image of the car x pixels from 
; the *right* margin of the BACKGROUND image 
(define (render ws)
  (place-image CAR
               (- ws (/ (image-width CAR) 2)) ; place the image by the right pixel
               ; to do so, move the WorldState back
               Y-CAR BACKGROUND))

; WorldState -> Boolean
; determines if the car has to stop (end of the scene)
(define (end? ws)
  (> ws (+ (image-width BACKGROUND) (image-width CAR))))

; WorldState Number Number String -> WorldState
; places the car at x-mouse
; if the given me is "button-down" 
; given: 21 10 20 "enter"
; wanted: 21
; given: 42 10 20 "button-down"
; wanted: 10
; given: 42 10 20 "move"
; wanted: 42
(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond
    [(string=? "button-down" me) x-mouse]
    [else x-position-of-car]))

(check-expect (hyper 21 10 20 "enter") 21)
(check-expect (hyper 42 10 20 "button-down") 10)
(check-expect (hyper 42 10 20 "move") 42)

; WorldState -> WorldState
; launches the program from some initial state 
(define (main ws)
   (big-bang ws
     [on-tick tock]
     [on-mouse hyper]
     [to-draw render]
     [stop-when end?]))