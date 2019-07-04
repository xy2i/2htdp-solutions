;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 101-other-repr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

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

(define initial-scene (place-image UFO (/ WIDTH 2) 5
                                   (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT) BG)))

(define PROXIMITY 15) ; the proximity at which the missile must hit the ufo
(define UFO-Y-SPEED 3) ; descending speed of the ufo
(define MISSILE-Y-SPEED 6) ; speed of the missile
(define TANK-MAX-VEL 10) ; the max velocity of a tank
(define TANK-FRICTION 2) ; the velocity the tank loses each tick
(define UFO-JUMPINESS 15) ; how much an ufo can jump around each tick

; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)
 
(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick 

(define-struct sigs [ufo tank missile])
; A SIGS.v2 (short for SIGS version 2) is a structure:
;   (make-sigs UFO Tank MissileOrNot)
; interpretation represents the complete state of a
; space invader game
 
; A MissileOrNot is one of: 
; – #false
; – Posn
; interpretation#false means the missile is in the tank;
; Posn says the missile is at that location

(define initial-state (make-sigs (make-posn (/ WIDTH 2) 5) (make-tank (/ WIDTH 2) 0) #false))
(define s1 (make-sigs (make-posn 20 10) (make-tank 28 -3) #false))
(define e1 (place-image UFO 20 10
                        (place-image TANK 28 (- HEIGHT TANK-HEIGHT) BG)))
(check-expect (si-render.v2 s1)
              e1)

(define s2 (make-sigs (make-posn 20 10)
                       (make-tank 28 -3)
                       (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define e2 (place-image UFO 20 10
                        (place-image TANK 28 (- HEIGHT TANK-HEIGHT)
                                     (place-image MISSILE 28 (- HEIGHT TANK-HEIGHT) BG))))
(check-expect (si-render.v2 s2)
              e2)

(define s3 (make-sigs (make-posn 20 100)
                       (make-tank 100 3)
                       (make-posn 22 103)))
(define e3 (place-image UFO 20 100
                        (place-image MISSILE 22 103
                                     (place-image TANK 100 (- HEIGHT TANK-HEIGHT) BG))))
(check-expect (si-render.v2 s3)
              e3)

; SIGS.v2 -> Image 
; renders the given game state on top of BACKGROUND 
(define (si-render.v2 s)
  (tank-render
    (sigs-tank s)
    (ufo-render (sigs-ufo s)
                (missile-render.v2 (sigs-missile s)
                                   BG))))

; Tank Image -> Image 
; adds t to the given image im
(define (tank-render t im)
  (place-image TANK (tank-loc t) (- HEIGHT TANK-HEIGHT) im))
 
; UFO Image -> Image 
; adds u to the given image im
(define (ufo-render u im)
  (place-image UFO (posn-x u) (posn-y u) im))


; MissileOrNot Image -> Image 
; adds an image of missile m to scene s
(check-expect (missile-render.v2 #false (place-image UFO 70 10
                        (place-image TANK 100 (- HEIGHT TANK-HEIGHT) BG)))
              (place-image UFO 70 10
                        (place-image TANK 100 (- HEIGHT TANK-HEIGHT) BG)))
(define (missile-render.v2 m s)
  (cond
    [(boolean? m) s] ; no missile, return the scene
    [(posn? m) (place-image MISSILE (posn-x m) (posn-y m) s)])) ; place the missile

; SIGS.v2 -> Boolean
; checks if the missile is near the ufo, or that the ufo has landed
(check-expect (si-game-over?.v2 s1) #false)
(check-expect (si-game-over?.v2 s2) #false)
(check-expect (si-game-over?.v2 s3) #true)
(check-expect (si-game-over?.v2 (make-sigs (make-posn 10 190) (make-tank 24 0) #false)) #true)
(check-expect (si-game-over?.v2 (make-sigs (make-posn 10 190) (make-tank 24 0) (make-posn 0 0))) #true)
(check-expect (si-game-over?.v2 (make-sigs (make-posn 10 10) (make-tank 24 0) (make-posn 7 10))) #true)

(define (si-game-over?.v2 s)
  (cond
    [(boolean? (sigs-missile s)) (ufo-land? (sigs-ufo s))]
    [else (or (close? (sigs-ufo s) (sigs-missile s))
                    (ufo-land? (sigs-ufo s)))]))

; Posn Posn -> Boolean
; check for two objects's proximity
(check-expect (close? (make-posn 0 0) (make-posn 1 1)) #true)
(check-expect (close? (make-posn 0 0) (make-posn 40 0)) #false)
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
(check-expect (si-render-final.v2 s3)
              (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                             (si-render.v2 s3)))
(check-expect (si-render-final.v2 (make-sigs (make-posn 10 190) (make-tank 24 0) #false))
              (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                             (si-render.v2 (make-sigs (make-posn 10 190) (make-tank 24 0) #false))))

(define (si-render-final.v2 s)
  (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                 (si-render.v2 s)))

; SIGS -> SIGS
; moves objects randomly
(define (si-move.v2 w)
  (si-move-proper.v2 w
                  (- UFO-JUMPINESS (random (* UFO-JUMPINESS 2)))))
  ; to create a random delta, we need a base,
  ; and a random number up to two times that base
  ; eg. with a base of 20, the random number generated will be 40
  ; we can then substract that random number from 20,
  ; giving us an equal chance of positive and negative deltas
  ; for 20, the expr is (- 20 (random 40))
 
; SIGS Number -> SIGS 
; moves the space-invader objects predictably by delta
(check-expect (si-move-proper.v2 (make-sigs (make-posn 40 10) (make-tank 24 10) #false)
                              5)
              (make-sigs (make-posn 45 13) (make-tank 34 8) #false))
(check-expect (si-move-proper.v2 (make-sigs (make-posn 40 20) (make-tank 24 0) (make-posn 7 40))
                              12)
              (make-sigs (make-posn 52 23) (make-tank 24 0) (make-posn 7 34)))

(define (si-move-proper.v2 w ufo-delta)
  (make-sigs (move-ufo (sigs-ufo w) ufo-delta)
             (move-tank (sigs-tank w))
             (move-missile.v2 (sigs-missile w))))

; Posn -> Posn
; moves an ufo, predictably
; the ufo must stay within the bounds of the field
(check-expect (move-ufo (make-posn 40 10) 5)
              (make-posn 45 13))
(check-expect (move-ufo (make-posn 20 20) 40)
              (make-posn 60 23))
(define (move-ufo u delta)
  (make-posn (ufo-bound-check (+ (posn-x u) delta))
             (+ (posn-y u) UFO-Y-SPEED)))

; Number -> Number
; bounds check for an UFO's x pos
; a little hacky
(check-expect (ufo-bound-check 39) 40)
(check-expect (ufo-bound-check 161) 160)
(define (ufo-bound-check x)
  (cond
   [(> x (- WIDTH UFO-WIDTH)) (- WIDTH UFO-WIDTH)]
   [(< x UFO-WIDTH) UFO-WIDTH]
   [else x]))


; Tank -> Tank
; moves an tank
(check-expect (move-tank (make-tank 24 10)) (make-tank 34 8))
(check-expect (move-tank (make-tank 30 0)) (make-tank 30 0))
(check-expect (move-tank (make-tank 30 -4)) (make-tank 26 -2))
(define (move-tank t)
  (cond
    [(> (tank-vel t) 0)
      (make-tank (+ (tank-loc t) (tank-vel t)) ; move by the current velocity
                 (- (tank-vel t) TANK-FRICTION))] ; each tick, we lose some velocity back to 0
    [(< (tank-vel t) 0)
      (make-tank (+ (tank-loc t) (tank-vel t)) ; move by the current velocity
                 (+ (tank-vel t) TANK-FRICTION))] ; each tick, we gain back to 0
    [else t])) ; if we are at 0, return the current tank (no movement)

; Posn -> Posn
; moves a missile
(check-expect (move-missile.v2 #false) #false)
(check-expect (move-missile.v2 (make-posn 7 40)) (make-posn 7 34))
(check-expect (move-missile.v2 (make-posn 0 100)) (make-posn 0 94))
(check-expect (move-missile.v2 (make-posn 0 6)) (make-posn 0 0))
(define (move-missile.v2 m)
  (cond
    [(boolean? m) m]
    [(posn? m)
     (make-posn (posn-x m)
             (- (posn-y m) MISSILE-Y-SPEED))])) ; the missile is climbing up, so it
; "loses" height by our representation of height

; SIGS KeyEvent -> SIGS
; moves or fires a missile
(check-expect (si-control.v2 (make-sigs (make-posn 20 10) (make-tank 28 -3) #false) "a")
              (make-sigs (make-posn 20 10) (make-tank 28 -3) #false))
(check-expect (si-control.v2 (make-sigs (make-posn 20 10) (make-tank 28 -3) #false) "left")
              (make-sigs (make-posn 20 10) (make-tank 28 -10) #false))
(check-expect (si-control.v2 (make-sigs (make-posn 20 10) (make-tank 28 -3) #false) "right")
              (make-sigs (make-posn 20 10) (make-tank 28 10) #false))
(check-expect (si-control.v2 (make-sigs (make-posn 20 10) (make-tank 28 -3) #false) " ")
              (make-sigs (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define (si-control.v2 s k)
  (cond
    [(string=? k "left") (direct-tank s k)]
    [(string=? k "right") (direct-tank s k)]
    [(string=? k " ") (fire-missile.v2 s)]
    [else s]))

; SIGS String -> SIGS
; Moves the tank to the left or right (refreshes its velocity)
(check-expect (direct-tank (make-sigs (make-posn 20 10) (make-tank 28 -3) #false)
                           "left")
              (make-sigs (make-posn 20 10) (make-tank 28 -10) #false))
(check-expect (direct-tank (make-sigs (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT)))
                           "left")
              (make-sigs (make-posn 20 10) (make-tank 28 -10) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(check-expect (direct-tank (make-sigs (make-posn 20 10) (make-tank 28 -3) #false)
                           "right")
              (make-sigs (make-posn 20 10) (make-tank 28 10) #false))
(check-expect (direct-tank (make-sigs (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT)))
                           "right")
              (make-sigs (make-posn 20 10) (make-tank 28 10) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define (direct-tank s direction)
  (make-sigs (sigs-ufo s)
             (make-tank
              (tank-loc (sigs-tank s))
              (max-vel direction))
             (sigs-missile s)))

; String -> Number
; returns the correct max velocity for a tank, going left or right
(check-expect (max-vel "left") (- TANK-MAX-VEL))
(check-expect (max-vel "right") TANK-MAX-VEL)
(define (max-vel dir)
  (cond
    [(string=? "left" dir) (- TANK-MAX-VEL)]
    [(string=? "right" dir) TANK-MAX-VEL]))

; SIGS -> SIGS
; fires a missile, if it is not fired
(check-expect (fire-missile.v2 (make-sigs (make-posn 20 10) (make-tank 28 -3) #false))
              (make-sigs (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(check-expect (fire-missile.v2 (make-sigs (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
              (make-sigs (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define (fire-missile.v2 s)
  (make-sigs (sigs-ufo s)
             (sigs-tank s)
             (cond
              [(boolean? (sigs-missile s))
                         (make-posn (tank-loc (sigs-tank s)) (- HEIGHT TANK-HEIGHT))]
              [else (sigs-missile s)])))

; SIGS -> SIGS
(define (main s)
  (big-bang s
    [on-tick si-move.v2 0.05]
    [on-key si-control.v2]
    [to-draw si-render.v2]
    [stop-when si-game-over?.v2 si-render-final.v2]))