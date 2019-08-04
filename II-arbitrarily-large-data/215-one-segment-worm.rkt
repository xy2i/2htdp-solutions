;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 215-one-segment-worm) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define-struct snake [posn dir])
; A Snake is a Struct.
; (make-snake Posn String)
; creates a snake with logical position Posn and direction String,
; one of "left", "down", "up" or "right"

(define SNAKE (circle 5 "solid" "red"))
(define OFFSET (/ (image-height SNAKE) 2)) ; offset to place the snake with place-image
(define BG (empty-scene 100 100)) ; logical size of the scene: 10 * 10

(define UP (make-posn 0 -1))
(define DOWN (make-posn 0 1))
(define LEFT (make-posn -1 0))
(define RIGHT (make-posn 1 0))

; Snake -> Snake
; moves the snake one logical unit per tick
(check-expect (move (make-snake (make-posn 0 0) "right"))
              (make-snake (make-posn 1 0) "right"))
(define (move s)
  (make-snake
   (make-posn
    (+ (posn-x (snake-posn s))
       (posn-x (vector (snake-dir s))))
    (+ (posn-y (snake-posn s))
       (posn-y (vector (snake-dir s)))))
   (snake-dir s)))

; String -> Posn
; gets the corresponding vector
(define (vector str)
  (cond
    [(string=? "left" str) LEFT]
    [(string=? "right" str) RIGHT]
    [(string=? "up" str) UP]
    [(string=? "down" str) DOWN]))
    
; Snake -> Snake
; turns the snake, without changing its position
(check-expect (turn (make-snake (make-posn 0 0) "left") "right")
              (make-snake (make-posn 0 0) "right"))
(define (turn s ke)
  (make-snake (snake-posn s)
              (cond
                [(string=? "left" ke) "left"]
                [(string=? "right" ke) "right"]
                [(string=? "up" ke) "up"]
                [(string=? "down" ke) "down"]
                [else (snake-dir s)])))

; Snake -> Snake
; renders the snake
(check-expect (render (make-snake (make-posn 0 0) "left"))
              (place-image SNAKE 5 5 BG))
(check-expect (render (make-snake (make-posn 2 3) "left"))
              (place-image SNAKE 25 35 BG))
(define (render s)
  (place-image SNAKE
               (+ OFFSET (* (posn-x (snake-posn s)) 10))
               (+ OFFSET (* (posn-y (snake-posn s)) 10))
               BG))

(define is (make-snake (make-posn 0 0) "right"))
(define (snake-main is)
  (big-bang is
    [on-tick move 0.25]
    [on-key turn]
    [to-draw render]))