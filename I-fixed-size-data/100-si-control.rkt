;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 100-si-control) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
 
; A Missile is a Posn. 
; interpretation (make-posn x y) is the missile's place

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])
; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game

(define initial-state (make-aim (make-posn (/ WIDTH 2) 5) (make-tank (/ WIDTH 2) 0)))
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
(check-expect (si-render-final s3)
              (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                             (si-render s3)))
(check-expect (si-render-final (make-aim (make-posn 10 190) (make-tank 24 0)))
              (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                             (si-render (make-aim (make-posn 10 190) (make-tank 24 0)))))

(define (si-render-final s)
  (overlay/align "center" "center" (text "GAME OVER" 18 "red")
                 (si-render s)))

; SIGS -> SIGS
; moves objects randomly
(define (si-move w)
  (si-move-proper w
                  (- UFO-JUMPINESS (random (* UFO-JUMPINESS 2)))))
  ; to create a random delta, we need a base,
  ; and a random number up to two times that base
  ; eg. with a base of 20, the random number generated will be 40
  ; we can then substract that random number from 20,
  ; giving us an equal chance of positive and negative deltas
  ; for 20, the expr is (- 20 (random 40))
 
; SIGS Number -> SIGS 
; moves the space-invader objects predictably by delta
(check-expect (si-move-proper (make-aim (make-posn 40 10) (make-tank 24 10))
                              5)
              (make-aim (make-posn 45 13) (make-tank 34 8)))
(check-expect (si-move-proper (make-fired (make-posn 40 20) (make-tank 24 0) (make-posn 7 40))
                              12)
              (make-fired (make-posn 52 23) (make-tank 24 0) (make-posn 7 34)))

(define (si-move-proper w ufo-delta)
  (cond
    [(aim? w)
     (make-aim (move-ufo (aim-ufo w) ufo-delta)
               (move-tank (aim-tank w)))]
    [(fired? w)
     (make-fired (move-ufo (fired-ufo w) ufo-delta)
                 (move-tank (fired-tank w))
                 (move-missile (fired-missile w)))]))

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
(check-expect (move-missile (make-posn 7 40)) (make-posn 7 34))
(check-expect (move-missile (make-posn 0 100)) (make-posn 0 94))
(check-expect (move-missile (make-posn 0 6)) (make-posn 0 0))
(define (move-missile m)
  (make-posn (posn-x m)
             (- (posn-y m) MISSILE-Y-SPEED))) ; the missile is climbing up, so it
; "loses" height by our representation of height

; SIGS KeyEvent -> SIGS
; moves or fires a missile
(check-expect (si-control (make-aim (make-posn 20 10) (make-tank 28 -3)) "a")
              (make-aim (make-posn 20 10) (make-tank 28 -3)))
(check-expect (si-control (make-aim (make-posn 20 10) (make-tank 28 -3)) "left")
              (make-aim (make-posn 20 10) (make-tank 28 -10)))
(check-expect (si-control (make-aim (make-posn 20 10) (make-tank 28 -3)) "right")
              (make-aim (make-posn 20 10) (make-tank 28 10)))
(check-expect (si-control (make-aim (make-posn 20 10) (make-tank 28 -3)) " ")
              (make-fired (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define (si-control s k)
  (cond
    [(string=? k "left") (direct-tank s k)]
    [(string=? k "right") (direct-tank s k)]
    [(string=? k " ") (fire-missile s)]
    [else s]))

; SIGS String -> SIGS
; Moves the tank to the left or right (refreshes its velocity)
(check-expect (direct-tank (make-aim (make-posn 20 10) (make-tank 28 -3))
                           "left")
              (make-aim (make-posn 20 10) (make-tank 28 -10)))
(check-expect (direct-tank (make-fired (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT)))
                           "left")
              (make-fired (make-posn 20 10) (make-tank 28 -10) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(check-expect (direct-tank (make-aim (make-posn 20 10) (make-tank 28 -3))
                           "right")
              (make-aim (make-posn 20 10) (make-tank 28 10)))
(check-expect (direct-tank (make-fired (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT)))
                           "right")
              (make-fired (make-posn 20 10) (make-tank 28 10) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define (direct-tank s direction)
  (cond
    [(aim? s)
     (make-aim (aim-ufo s)
               (make-tank
                (tank-loc (aim-tank s))
                (max-vel direction)))]
    [(fired? s)
     (make-fired (fired-ufo s)
                 (make-tank
                  (tank-loc (fired-tank s))
                  (max-vel direction))
                 (fired-missile s))]))

; String -> Number
; returns the correct max velocity for a tank, going left or right
(check-expect (max-vel "left") (- TANK-MAX-VEL))
(check-expect (max-vel "right") TANK-MAX-VEL)
(define (max-vel dir)
  (cond
    [(string=? "left" dir) (- TANK-MAX-VEL)]
    [(string=? "right" dir) TANK-MAX-VEL]))

; SIGS -> Fired
; fires a missile, if it is not fired
(check-expect (fire-missile (make-aim (make-posn 20 10) (make-tank 28 -3)))
              (make-fired (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(check-expect (fire-missile (make-fired (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
              (make-fired (make-posn 20 10) (make-tank 28 -3) (make-posn 28 (- HEIGHT TANK-HEIGHT))))
(define (fire-missile s)
  (if (aim? s) ; we have an Aim, make it a Fired
      (make-fired (aim-ufo s)
                  (aim-tank s)
                  (make-posn (tank-loc (aim-tank s))
                             (- HEIGHT TANK-HEIGHT)))
      s)) ; already a Fired, return the same state (do nothing)

; SIGS -> SIGS
(define (main s)
  (big-bang s
    [on-tick si-move 0.05]
    [on-key si-control]
    [to-draw si-render]
    [stop-when si-game-over? si-render-final]))
    