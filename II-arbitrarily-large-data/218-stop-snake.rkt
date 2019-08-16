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

(define-struct sgame [snake food])
; A Snake-game is a struct.
; (make-sg Snake Posn)
; creates a game with a snake (a List-of-segments)
; and a single food at the posn

(define SNAKE (circle 5 "solid" "red"))
(define SNAKE-HEAD (circle 5 "solid" "orange"))
(define FRUIT (overlay/xy (rectangle 4 7 "solid" "red") -3 2 (circle 5 "solid" "green")))

(define LSIZE 10) ; the logical size of the scene
(define MAX LSIZE) 
(define OFFSET (/ (image-height SNAKE) 2)) ; offset to place the snake with place-image
(define BG (empty-scene (* (image-height SNAKE) LSIZE)
                        (* (image-height SNAKE) LSIZE))) ; logical size of the scene: 10 * 10

(define UP (make-posn 0 -1))
(define DOWN (make-posn 0 1))
(define LEFT (make-posn -1 0))
(define RIGHT (make-posn 1 0))

; Snake-game -> Snake-game
; moves the snake, checks for eating food and creates new food if eaten
(define (tock sg)
  (if (eaten-food? (move sg)) ; if we move the snake once, is it on a food?
      (grow-snake-change-food sg) ; move, while growing the snake and changing the food's position
      (move sg)))

; Snake-game -> Snake-game
; moves the snake
(define (move sg)
  (make-sgame
   (move/snake (sgame-snake sg))
   (sgame-food sg)))
  
; Snake-game -> Snake-game
; grows the snake and places a new food
(define (grow-snake-change-food sg)
  (make-sgame
   (grow-snake (sgame-snake sg) (sgame-food sg))
   (food-create (sgame-food sg))))

; Snake -> Snake
; eats a food at the given posn and grows one segment
(check-expect (grow-snake (list (make-seg (make-posn 0 0) "right")
                                (make-seg (make-posn 1 0) "right"))
                          (make-posn 2 0))
              (list (make-seg (make-posn 0 0) "right")
                    (make-seg (make-posn 1 0) "right")
                    (make-seg (make-posn 2 0) "right")))

(define (grow-snake snake food)
  (cond
    [(empty? (rest snake)) (cons (first snake) ; snake head
                                 (cons (make-seg food
                                                 ; creates a new segment (new snake head)...
                                                 ; with the same direction as the old snake's head
                                                 (seg-dir (first snake)))
                                       '()))]
    [else ; more than one segment
     (cons (first snake)
                (grow-snake (rest snake) food))])) ; recur until we get the head

; Posn -> Posn 
; generates a random food, if the food is not in the same place
(check-satisfied (food-create (make-posn 1 1)) not=-1-1?)
(define (food-create p)
  (food-check-create
     p (make-posn (random MAX) (random MAX))))
 
; Posn Posn -> Posn 
; generative recursion 
; checks if the food is not in the same place, calls food-create again otherwise
(define (food-check-create p candidate)
  (if (equal? p candidate) (food-create p) candidate))
 
; Posn -> Boolean
; use for testing only 
(define (not=-1-1? p)
  (not (and (= (posn-x p) 1) (= (posn-y p) 1))))
    
; Snake -> Snake
; moves an entire snake
(check-expect (move/snake (list
                     (make-seg (make-posn 0 0) "right")
                     (make-seg (make-posn 1 0) "right")))
              (list (make-seg (make-posn 1 0) "right")
                    (make-seg (make-posn 2 0) "right")))
(check-expect (move/snake (list
                     (make-seg (make-posn 0 0) "right")
                     (make-seg (make-posn 1 0) "down")))
              (list (make-seg (make-posn 1 0) "down")
                    (make-seg (make-posn 1 1) "down")))
(define (move/snake s)
  (cond
    [(empty? (rest s)) ; only one segment?
     (cons (move/segment (first s) (seg-dir (first s))) ; move it in its direction
           '())]
    [else ; at least two segments
     (cons (move/segment (first s) (seg-dir (second s))) 
           ; each direction change is propagated from the head (last s) to the tail (first s)
           ; recursively, by taking the direction of the next segment each time
           ; a snake that has "right" "right" "down"
           ; will become      "right" "down"  "down"
           ; then next tick   "down"  "down"  "down"
           (move/snake (rest s)))]))
    
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

; Snake-game -> Boolean
; check if the food was eaten
(check-expect (eaten-food?
               (make-sgame
                (list (make-seg (make-posn 0 0) "right")
                      (make-seg (make-posn 0 1) "down"))
                (make-posn 2 2))) #false)
(check-expect (eaten-food?
               (make-sgame
                (list (make-seg (make-posn 0 0) "right")
                      (make-seg (make-posn 0 1) "down"))
                (make-posn 0 1))) #true)
(define (eaten-food? sg)
  (member? (sgame-food sg) ; posn of food
           (segs-posn (sgame-snake sg)))) ; list of posns for the snake

; Snake-game -> Snake-game
; turns the snake in a snake-game
(check-expect (turn
               (make-sgame (list (make-seg (make-posn 2 0) "left")
                                 (make-seg (make-posn 1 0) "left")
                                 (make-seg (make-posn 0 0) "down")
                                 (make-seg (make-posn 0 1) "down"))
                           (make-posn 5 5))
               "right")
              (make-sgame (list (make-seg (make-posn 2 0) "left")
                                 (make-seg (make-posn 1 0) "left")
                                 (make-seg (make-posn 0 0) "down")
                                 (make-seg (make-posn 0 1) "right"))
                          (make-posn 5 5)))
(define (turn sg ke)
  (make-sgame
   (turn/snake (sgame-snake sg) ke)
   (sgame-food sg)))
  
; Snake -> Snake
; turns the snake, without changing its position
(check-expect (turn/snake (list (make-seg (make-posn 2 0) "left")
                                (make-seg (make-posn 1 0) "left")
                                (make-seg (make-posn 0 0) "down")
                                (make-seg (make-posn 0 1) "down")) "right")
              (list (make-seg (make-posn 2 0) "left")
                    (make-seg (make-posn 1 0) "left")
                    (make-seg (make-posn 0 0) "down")
                    (make-seg (make-posn 0 1) "right")))
(define (turn/snake s ke)
  (cond
    [(empty? (rest s)) ; only turn the head
     (cons
      (make-seg (seg-posn (first s))
                (cond ; explicit key handler
                  [(string=? "left" ke) "left"]
                  [(string=? "right" ke) "right"]
                  [(string=? "up" ke) "up"]
                  [(string=? "down" ke) "down"]
                  [else (seg-dir (first s))]))
      '())]
    [else (cons (first s) (turn/snake (rest s) ke))]))

; Snake-game -> Image
; renders a snake, and food
(check-expect (render (make-sgame (list (make-seg (make-posn 0 0) "left"))
                                  (make-posn 2 2)))
                      (place-image FRUIT 25 25 (render/snake
                                                (list (make-seg (make-posn 0 0) "left")))))
(define (render sg)
  (place-image FRUIT
               (+ OFFSET (* (posn-x (sgame-food sg)) 10))
               (+ OFFSET (* (posn-y (sgame-food sg)) 10))
               (render/snake (sgame-snake sg))))

; Snake -> Image
; renders a snake
(check-expect (render/snake (list (make-seg (make-posn 0 0) "left")))
              (place-image SNAKE-HEAD 5 5 BG))
(check-expect (render/snake (list (make-seg (make-posn 2 3) "left")))
              (place-image SNAKE-HEAD 25 35 BG))
(check-expect (render/snake (list (make-seg (make-posn 0 0) "left")
                            (make-seg (make-posn 1 0) "left")))
              (place-image SNAKE-HEAD 15 5 (place-image SNAKE 5 5 BG)))

(define (render/snake s)
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
                  (render/snake (rest s)))]))

; Snake-game -> Image
; renders the snake, and says he's out
(define (render/out s)
  (overlay (text
            (cond
              [(oob? (sgame-snake s)) "worm hit wall"]
              [(self-eat? (sgame-snake s)) "worm ate himself"])
            12
            "black")
           (render s)))
  
; Snake-game -> Boolean
; check if the snake is out of bounds
(check-expect (out? (make-sgame (list (make-seg (make-posn 0 0) "left"))
                                (make-posn 5 5)))
              #false)
(check-expect (out? (make-sgame (list (make-seg (make-posn -1 0) "left"))
                                (make-posn 5 5)))
              #true)
(check-expect (out? (make-sgame (list (make-seg (make-posn 10 10) "left"))
                                (make-posn 5 5)))
              #true)
(define (out? sg)
  (or (oob? (sgame-snake sg))
      (self-eat? (sgame-snake sg))))

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
; extracts a posn from each segment of a list
(define (segs-posn s)
  (cond
    [(empty? (rest s)) (cons (seg-posn (first s)) '())]
    [else
     (cons (seg-posn (first s)) (segs-posn (rest s)))]))

; initial state
(define is
  (make-sgame
   (list (make-seg (make-posn 0 0) "right")
                 (make-seg (make-posn 1 0) "right"))
   (make-posn 6 6)))

(define (snake-main is)
  (big-bang is
    [on-tick tock 0.25]
    [on-key turn]
    [to-draw render]
    [stop-when out? render/out]))

(snake-main is)