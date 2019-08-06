;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 218-stop-snake) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define-struct seg [posn dir])
; A Segment is a Struct.
; (make-seg List-of-Posn String)
; creates a segment with logical position Posn and direction String,
; one of "left", "down", "up" or "right"

; A Snake is a List-of-segments.

(define SNAKE (circle 5 "solid" "red"))
(define SNAKE-HEAD (circle 5 "solid" "orange"))

(define LSIZE 10) ; the logical size of the scene
(define OFFSET (/ (image-height SNAKE) 2)) ; offset to place the snake with place-image
(define BG (empty-scene (* (image-height SNAKE) LSIZE)
                        (* (image-height SNAKE) LSIZE))) ; logical size of the scene: 10 * 10

(define UP (make-posn 0 -1))
(define DOWN (make-posn 0 1))
(define LEFT (make-posn -1 0))
(define RIGHT (make-posn 1 0))

; Snake -> Snake
; moves an entire snake
(check-expect (move (list
                     (make-seg (make-posn 0 0) "right")
                     (make-seg (make-posn 1 0) "right")))
              (list (make-seg (make-posn 1 0) "right")
                    (make-seg (make-posn 2 0) "right")))
(define (move s)
  (cond
    [(empty? (rest s)) ; only one segment?
     (cons (move/segment (first s) (seg-dir (first s))) ; move it in its direction
           '())]
    [else
     (cons (move/segment (first s) (seg-dir (second s))) ; at least two segments
           (move (rest s)))]))
    
; Segment -> Segment
; moves a segment one logical unit per tick,
; and changes its dir to the next in line
(check-expect (move/segment (make-seg (make-posn 0 0) "right") "right")
              (make-seg (make-posn 1 0) "right"))
(define (move/segment s dir)
  (make-seg
   (make-posn
    (+ (posn-x (seg-posn s))
       (posn-x (vector (seg-dir s)))) ; move in our own direction first..
    (+ (posn-y (seg-posn s))
       (posn-y (vector (seg-dir s)))))
   dir)) ; then set our dir to that of the next segment

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
(check-expect (turn (list (make-seg (make-posn 2 0) "left")
                          (make-seg (make-posn 1 0) "left")
                          (make-seg (make-posn 0 0) "down")
                          (make-seg (make-posn 0 1) "down")) "right")
              (list (make-seg (make-posn 2 0) "left")
                    (make-seg (make-posn 1 0) "left")
                    (make-seg (make-posn 0 0) "down")
                    (make-seg (make-posn 0 1) "right")))
(define (turn s ke)
  (cond
    [(empty? (rest s)) ; only turn the first segment
     (cons
      (make-seg (seg-posn (first s))
                (cond
                  [(string=? "left" ke) "left"]
                  [(string=? "right" ke) "right"]
                  [(string=? "up" ke) "up"]
                  [(string=? "down" ke) "down"]
                  [else (seg-dir (first s))]))
      '())]
    [else (cons (first s) (turn (rest s) ke))]))

; Segment -> Image
; renders a single segment
(check-expect (render (list (make-seg (make-posn 0 0) "left")))
              (place-image SNAKE-HEAD 5 5 BG))
(check-expect (render (list (make-seg (make-posn 2 3) "left")))
              (place-image SNAKE-HEAD 25 35 BG))
(check-expect (render (list (make-seg (make-posn 0 0) "left")
                            (make-seg (make-posn 1 0) "left")))
              (place-image SNAKE-HEAD 15 5 (place-image SNAKE 5 5 BG)))

(define (render s)
  (cond
    [(empty? (rest s))
     (place-image SNAKE-HEAD
                  (+ OFFSET (* (posn-x (seg-posn (first s))) 10))
                  (+ OFFSET (* (posn-y (seg-posn (first s))) 10))
                  BG)]
    [else
     (place-image SNAKE
                  (+ OFFSET (* (posn-x (seg-posn (first s))) 10))
                  (+ OFFSET (* (posn-y (seg-posn (first s))) 10))
                  (render (rest s)))]))

; Snake -> Image
; renders the snake, and says he's out
(define (render/out s)
  (overlay (text
            (cond
              [(oob? s) "worm hit wall"]
              [(self-eat? s) "worm ate himself"])
            12
            "black")
           (render s)))
  
; Snake -> Boolean
; check if the snake is out of bounds
(check-expect (out? (list (make-seg (make-posn 0 0) "left")))
              #false)
(check-expect (out? (list (make-seg (make-posn -1 0) "left")))
              #true)
(check-expect (out? (list (make-seg (make-posn 10 10) "left")))
              #true)
(define (out? s)
  (or (oob? s) (self-eat? s)))

; Snake -> Boolean
; check if a snake is out of bounds (if its head is out)
(define (oob? s)
  (or
   (< (posn-x (seg-posn (last s))) 0)
   (< (posn-y (seg-posn (last s))) 0)
   (> (posn-x (seg-posn (last s))) (sub1 LSIZE))
   (> (posn-y (seg-posn (last s))) (sub1 LSIZE))))
; Snake -> Segment
; get the last segment
(define (last s)
  (cond
    [(empty? (rest s)) (first s)]
    [else (last (rest s))]))

; Snake -> Boolean
; checks if a snake has hit himself
(check-expect (self-eat? (list (make-seg (make-posn 0 0) "right")))
              #false)
(check-expect (self-eat? (list (make-seg (make-posn 0 0) "right")
                               (make-seg (make-posn 1 0) "right")))
              #false)
(check-expect (self-eat? (list (make-seg (make-posn 0 0) "right")
                               (make-seg (make-posn 1 0) "right")
                               (make-seg (make-posn 0 0) "left")))
              #true)
(define (self-eat? s)
  (cond
    [(empty? (rest s)) #false] ; a snake of one segment cannot run into itself
    [else (or (member? (seg-posn (first s))
                       (segs-posn (rest s)))
              (self-eat? (rest s)))]))

; Snake -> List-of-posn
; extracts a posn from each segment
(define (segs-posn s)
  (cond
    [(empty? (rest s)) (cons (seg-posn (first s)) '())]
    [else
     (cons (seg-posn (first s)) (segs-posn (rest s)))]))

(define is (list (make-seg (make-posn 0 0) "right")
                 (make-seg (make-posn 1 0) "right")
                 (make-seg (make-posn 2 0) "right")
                 (make-seg (make-posn 3 0) "right")
                 (make-seg (make-posn 4 0) "right")
                 (make-seg (make-posn 5 0) "right")
                 (make-seg (make-posn 6 0) "right")
                 (make-seg (make-posn 7 0) "right")))
(define (snake-main is)
  (big-bang is
    [on-tick move 0.25]
    [on-key turn]
    [to-draw render]
    [stop-when out? render/out]))