;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 097-design-render) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define WIDTH 200)
(define HEIGHT 200)
(define BG (empty-scene WIDTH HEIGHT))

(define TANK-HEIGHT (/ HEIGHT 10))
(define TANK-WIDTH (/ WIDTH 5))
(define TANK (rectangle TANK-WIDTH TANK-HEIGHT "solid" "blue"))

(define UFO-HEIGHT (/ HEIGHT 10))
(define UFO-WIDTH (/ WIDTH 5))
(define UFO (overlay
             (circle (/ UFO-HEIGHT 3) "solid" "green")
             (rectangle UFO-WIDTH (/ UFO-HEIGHT 4) "solid" "green")))

(define MISSILE (triangle (/ HEIGHT 12) "solid" "black"))

(define initial-scene (place-image UFO 50 5
                                   (place-image TANK 50 (- HEIGHT TANK-HEIGHT) BG)))

; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)
 
(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick 
 
; A Missile is a Posn. 
; interpretation (make-posn x y) is the missile's place

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])
; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game

(define e1 (place-image UFO 20 10
                        (place-image TANK 28 (- HEIGHT TANK-HEIGHT) BG)))
(check-expect (si-render (make-aim (make-posn 20 10) (make-tank 28 -3)))
              e1)


(define e2 (place-image UFO 20 10
                        (place-image TANK 28 (- HEIGHT TANK-HEIGHT)
                                     (place-image MISSILE 28 (- HEIGHT TANK-HEIGHT) BG))))
(check-expect (si-render (make-fired (make-posn 20 10)
                                     (make-tank 28 -3)
                                     (make-posn 28 (- HEIGHT TANK-HEIGHT))))
              e2)

(define e3 (place-image UFO 20 100
                        (place-image MISSILE 22 103
                                     (place-image TANK 100 (- HEIGHT TANK-HEIGHT) BG))))
(check-expect (si-render (make-fired (make-posn 20 100)
                                     (make-tank 100 3)
                                     (make-posn 22 103)))
              e3)

; SIGS -> Image
; renders the given game state on top of BACKGROUND 
; for examples see figure 32
(define (si-render s)
  (cond
    [(aim? s)
     (tank-render (aim-tank s)
                  (ufo-render (aim-ufo s) BG))]
    [(fired? s)
     (tank-render
      (fired-tank s)
      (ufo-render (fired-ufo s)
                  (missile-render (fired-missile s)
                                  BG)))]))

; Tank Image -> Image 
; adds t to the given image im
(define (tank-render t im)
  (place-image TANK (tank-loc t) (- HEIGHT TANK-HEIGHT) im))
 
; UFO Image -> Image 
; adds u to the given image im
(define (ufo-render u im)
  (place-image UFO (posn-x u) (posn-y u) im))

; Missile Image -> Image 
; adds m to the given image im
(define (missile-render m im)
  (place-image MISSILE (posn-x m) (posn-y m) im))

;; Ex. 97
; The two functions produce the same result when any of the components are not on top of each other.
; If they are, then the order of the overlays will matter.