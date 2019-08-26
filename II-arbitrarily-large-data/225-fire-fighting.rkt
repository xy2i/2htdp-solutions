;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 225-fire-fighting) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH 200)
(define HEIGHT 200)
(define BG (empty-scene WIDTH HEIGHT))
(define HELI-HEAD (overlay (rectangle 2 20 "solid" "blue")
                           (rectangle 20 2 "solid" "blue")
                           (circle 5 "solid" "gray")))
(define BRANCH (rectangle 40 2 "solid" "gray"))
(define HELI-TAIL (overlay (rectangle 2 8 "solid" "blue")
                           (rectangle 8 2 "solid" "blue")
                           (square 4 "solid" "green")))
(define HELI (overlay/align "left" "middle" HELI-HEAD
                            (overlay/align "right" "middle" HELI-TAIL
                                           BRANCH)))
(define FIRE (triangle 15 "solid" "red"))

(define FRICTION 2) ; the friction in both direction: how much speed the heli loses each tick
(define UP (make-posn 0 -10)) ; vectors
(define DOWN (make-posn 0 10))
(define LEFT (make-posn -10 0))
(define RIGHT (make-posn 10 0))
(define PROXIMITY 20) ; the proximity to a fire needed to extinguish it
(define TIME 800) ; time (in ticks) given
(define NEW-FIRE-TIME 50) ; interval after which a new fire arrives
(define NEW-FIRE-NUM 4)

(define-struct fire [x y])
; A Fire is a Posn.
; (make-fire x y)

(define-struct heli [pos speed])
; A Heli is a Struct.
; (make-heli Posn Posn)
; creates an heli with a position of pos
; and speed in the two directions of speed

(define-struct fight [heli lof time])
; A Fire-fight is a Struct.
; (make-fight Posn List-of-Fires Number)

(define ff0 (make-fight (make-heli (make-posn 30 30) (make-posn 10 10)) (list (make-fire 10 10)) 800))
(define ff1 (make-fight (make-heli (make-posn 30 30) (make-posn 10 10)) (list (make-fire 10 10) (make-fire 40 40) (make-fire 70 70)) 10))
(define ff2 (make-fight (make-heli (make-posn 30 30) (make-posn 10 10)) '() 5))

; Fire-fight -> Image
; renders the game
(define (render f)
  (place-image (text (number->string (fight-time f)) 24 "olive")
               80 80
               (render/heli f)))

; Fire-fight -> Image
; renders the heli and fires
(check-expect (render/heli ff0)
              (place-image HELI 30 30
                           (place-image FIRE 10 10 BG)))
(check-expect (render/heli ff1)
              (place-image HELI 30 30
                           (place-image FIRE 10 10
                                        (place-image FIRE 40 40
                                                     (place-image FIRE 70 70 BG)))))
(check-expect (render/heli ff2)
              (place-image HELI 30 30 BG))
(define (render/heli f)
  (place-image HELI
               (posn-x (heli-pos (fight-heli f)))
               (posn-y (heli-pos (fight-heli f)))
               (render/fire (fight-lof f) BG)))

; List-of-fires -> Image
; renders each fire
(define (render/fire lof im)
  (cond
    [(empty? lof) im]
    [else
     (place-image FIRE
                  (fire-x (first lof))
                  (fire-y (first lof))
                  (render/fire (rest lof) im))]))

; Fire-fight -> Fire-fight
; counts down the time
(check-expect (fight-time (count-down ff0)) 799)
(define (count-down f)
  (make-fight
   (physics (fight-heli f))
   (generate-fire 2 (fight-lof f))
   (sub1 (fight-time f))))

; Posn -> Posn
; apply physics to the heli
(check-expect (physics (make-heli (make-posn 30 30) (make-posn 10 10)))
                       (make-heli (make-posn 40 40) (make-posn 8 8)))
(define (physics h)
  (make-heli
   (make-posn ; position: increase
    (+ (posn-x (heli-pos h)) (posn-x (heli-speed h)))
    (+ (posn-y (heli-pos h)) (posn-y (heli-speed h))))
   (make-posn ; speed: decrease by friction, if not 0
    (cond
      [(> (posn-x (heli-speed h)) 0) (- (posn-x (heli-speed h)) FRICTION)]
      [(< (posn-x (heli-speed h)) 0) (+ (posn-x (heli-speed h)) FRICTION)]
      [else 0])
    (cond
      [(> (posn-y (heli-speed h)) 0) (- (posn-y (heli-speed h)) FRICTION)]
      [(< (posn-y (heli-speed h)) 0) (+ (posn-y (heli-speed h)) FRICTION)]
      [else 0]))))

; List-of-fires -> List-of-fires
; creates new fires if interval is respected
; compiler bug
;(define (new-fires lof time)
;  (if (= (modulo time NEW-FIRE-TIME) 0)
;      (generate-fire NEW-FIRE-NUM lof)
;      lof))

; List-of-fires -> List-of-fires
; add random fires to the list
(define (generate-fire number lof)
  (cond
    [(empty? number) lof]
    [else
     (cons (make-fire (random WIDTH) (random HEIGHT))
           (generate-fire (sub1 number) lof))]))

; FireFight -> FireFight
; directs the heli
(check-expect (handler (make-fight (make-heli (make-posn 30 30) (make-posn 10 10)) '() 20) "up")
              (make-fight (make-heli (make-posn 30 30) (make-posn 0 -10)) '() 20))
(check-expect (handler (make-fight (make-heli (make-posn 12 12) (make-posn 0 0))
                                   (list (make-fire 10 10))
                                   20)
                       " ")
              (make-fight (make-heli (make-posn 12 12) (make-posn 0 0))
                                   '()
                                   20))
(define (handler f ke)
  (make-fight
   (direct (fight-heli f) ke)
   (collide (fight-lof f) ke
                       (heli-pos (fight-heli f))) ; water is discharged at current position
   (fight-time f)))

; Heli -> Heli
; directs the heli
(define (direct h ke)
  (make-heli
    (heli-pos h)
    (cond
      [(string=? "up" ke) UP]
      [(string=? "down" ke) DOWN]
      [(string=? "left" ke) LEFT]
      [(string=? "right" ke) RIGHT]
      [else (heli-speed h)])))

; List-of-fires KeyEvent -> List-of-fires
; checks for an extinguishement if the key is space
(define (collide lof ke pos)
  (if (string=? ke " ")
      (extinguish lof pos)
      lof)) ; didn't press space, don't extinguish

; List-of-fires Posn -> List-of-fires
; extinguishes all the fires that are near the water-dropoff point at Posn
(check-expect (extinguish (list (make-fire 10 10)) (make-posn 12 12))
              '())
(define (extinguish lof p)
  (cond
    [(empty? lof) '()]
    [else
     (if (close? (first lof) p)
         (extinguish (rest lof) p) ; fire disappears from the list
         (cons (first lof)  (extinguish (rest lof) p)))])) ; otherwhise it stays
  
; Fire Posn -> Boolean
; check if a posn is near a fire
(define (close? f p)
  (if (<=
       (inexact->exact ; distance formula
        (sqrt (+ (sqr (- (fire-x f) (posn-x p)))
                 (sqr (- (fire-y f) (posn-y p))))))
       PROXIMITY) #true #false))

;(main is) to run
(define is (make-fight (make-heli (make-posn 100 100) (make-posn 0 0)) (make-fire 10 10) TIME))
(define (main is)
  (big-bang is
    [on-tick count-down 0.1]
    [on-key handler]
    [to-draw render]))