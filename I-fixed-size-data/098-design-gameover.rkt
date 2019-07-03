;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 098-design-gameover) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define PROXIMITY 5) ; the proximity at which the missile must hit the ufo

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

(define s1 (make-aim (make-posn 20 10) (make-tank 28 -3)))
(define e1 (place-image UFO 20 10
                        (place-image TANK 28 (- HEIGHT TANK-HEIGHT) BG)))
(check-expect (si-render s1)
              e1)

(define s2 (make-fired (make-posn 20 10)
                       (make-tank 28 -3)
                       (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define e2 (place-image UFO 20 10
                        (place-image TANK 28 (- HEIGHT TANK-HEIGHT)
                                     (place-image MISSILE 28 (- HEIGHT TANK-HEIGHT) BG))))
(check-expect (si-render s2)
              e2)

(define s3 (make-fired (make-posn 20 100)
                       (make-tank 100 3)
                       (make-posn 22 103)))
(define e3 (place-image UFO 20 100
                        (place-image MISSILE 22 103
                                     (place-image TANK 100 (- HEIGHT TANK-HEIGHT) BG))))
(check-expect (si-render s3)
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

; SIGS -> Boolean
; checks if the missile is near the ufo, or that the ufo has landed
(check-expect (si-game-over? s1) #false)
(check-expect (si-game-over? s2) #false)
(check-expect (si-game-over? s3) #true)
(check-expect (si-game-over? (make-aim (make-posn 10 190) (make-tank 24 0))) #true)
(check-expect (si-game-over? (make-fired (make-posn 10 190) (make-tank 24 0) (make-posn 0 0))) #true)
(check-expect (si-game-over? (make-fired (make-posn 10 10) (make-tank 24 0) (make-posn 7 10))) #true)

(define (si-game-over? s)
  (cond
    [(aim? s) (ufo-land? (aim-ufo s))]
    [(fired? s) (or (close? (fired-ufo s) (fired-missile s))
                    (ufo-land? (fired-ufo s)))]))

; Posn Posn -> Boolean
; check for two objects's proximity
(check-expect (close? (make-posn 0 0) (make-posn 1 1)) #true)
(check-expect (close? (make-posn 0 0) (make-posn 6 0)) #false)
(define (close? a b)
  (if (<=
       (inexact->exact
        (sqrt (+ (sqr (- (posn-x a) (posn-x b)))
                 (sqr (- (posn-y a) (posn-y b))))))
       PROXIMITY) #true #false))

; UFO -> Boolean
; check if an ufo has landed
(check-expect (ufo-land? (make-posn 0 170)) #false)
(check-expect (ufo-land? (make-posn 0 180)) #true)
(check-expect (ufo-land? (make-posn 0 190)) #true)
(define (ufo-land? u)
  (>= (posn-y u) (* 9 (/ HEIGHT 10))))

; SIGS -> Image
; renders the final state
(check-expect (si-render-final s3)
              (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                             (si-render s3)))
(check-expect (si-render-final (make-aim (make-posn 10 190) (make-tank 24 0)))
              (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                             (si-render (make-aim (make-posn 10 190) (make-tank 24 0)))))

(define (si-render-final s)
  (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                 (si-render s)))