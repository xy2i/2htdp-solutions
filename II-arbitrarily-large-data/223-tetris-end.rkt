;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 223-tetris-end) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)


(define WIDTH 10) ; # of blocks, horizontally
(define HEIGHT 10) ; # of blocks vertically
(define SIZE 10) ; blocks are squares
(define SCENE-SIZE (* WIDTH SIZE))
(define SCENE-HEIGHT (* HEIGHT SIZE))

(define BLOCK ; red squares with black rims
  (overlay
   (square (- SIZE 1) "solid" "red")
   (square SIZE "outline" "black")))
(define BG (empty-scene SCENE-SIZE SCENE-HEIGHT))


(define-struct tetris [block landscape])
(define-struct block [x y])
 
; A Tetris is a structure:
;   (make-tetris Block Landscape)
; A Landscape is one of: 
; – '() 
; – (cons Block Landscape)
; A Block is a structure:
;   (make-block N N)
 
; interpretations
; (make-block x y) depicts a block whose left 
; corner is (* x SIZE) pixels from the left and
; (* y SIZE) pixels from the top;
; (make-tetris b0 (list b1 b2 ...)) means b0 is the
; dropping block, while b1, b2, and ... are resting


; instances
(define landscape0 (list (make-block 2 (- HEIGHT 1)) (make-block 3 (- HEIGHT 1))))
(define block-dropping0 (make-block 0 5))
(define block-dropping1 (make-block 0 6)) ; descending
(define block-landed (make-block 0 (- HEIGHT 1)))
(define block-on-block (make-block 0 (- HEIGHT 2)))
(define tetris0-drop (make-tetris block-dropping0 landscape0))
(define tetris0-drop2 (make-tetris block-dropping1 landscape0))
(define tetris0-land (make-tetris block-landed landscape0))
(define landscape1 (cons block-landed landscape0))
(define tetris-drop-on-block (make-tetris block-on-block landscape1))
(define tetris-over (make-tetris block-landed (list (make-block 0 9)
                                                    (make-block 0 8)
                                                    (make-block 0 7)
                                                    (make-block 0 6)
                                                    (make-block 0 5)
                                                    (make-block 0 4)
                                                    (make-block 0 3)
                                                    (make-block 0 2)
                                                    (make-block 0 1)
                                                    (make-block 0 0))))


; Tetris -> Image
; renders a tetris
(check-expect (tetris-render tetris0-drop)
              (place-image BLOCK 5 55
                           (place-image BLOCK 25 95
                                        (place-image BLOCK 35 95 BG))))
(check-expect (tetris-render tetris0-land)
              (place-image BLOCK 5 95
                           (place-image BLOCK 25 95
                                        (place-image BLOCK 35 95 BG))))
             
(define (tetris-render t)
  (place-image BLOCK
               (+ (* (block-x (tetris-block t)) SIZE) 5)
               (+ (* (block-y (tetris-block t)) SIZE) 5)
               (tetris-render/landscape (tetris-landscape t))))

; Landscape -> Image
; renders a landscape
(check-expect (tetris-render/landscape landscape0)
              (place-image BLOCK 25 95
                           (place-image BLOCK 35 95 BG)))
              
(define (tetris-render/landscape l)
  (cond
    [(empty? l) BG] ; no blocks to render left
    [else
     (place-image BLOCK
                  (+ (* (block-x (first l)) SIZE) 5)
                  (+ (* (block-y (first l)) SIZE) 5)
                  (tetris-render/landscape (rest l)))]))

; Tetris KeyEvent -> Tetris
; moves a block left or right
(define (direct t ke)
  (make-tetris
   (direct/block (tetris-block t) ke)
   (tetris-landscape t)))

; Block KeyEvent -> Block
; moves a block left or right, within the confines of the screen
(check-expect (direct/block (make-block 0 4) "right")
              (make-block 1 4))
(check-expect (direct/block (make-block 0 4) "left")
              (make-block 0 4))
(check-expect (direct/block (make-block (- WIDTH 1) 4) "right")
              (make-block (- WIDTH 1) 4))
(define (direct/block b ke)
  (make-block
   (x-bound-check
    (cond
      [(string=? ke "left") (sub1 (block-x b))]
      [(string=? ke "right") (add1 (block-x b))]
      [else (block-x b)]))
   (block-y b))) ; y is unchanged

; Number -> Number
; bound check for a block's x position
(define (x-bound-check x)
  (cond
    [(< x 0) 0] ; goes out of the left boundary
    [(> x (sub1 WIDTH)) (sub1 WIDTH)] ; goes out of the right boundary
    [else x]))

; Tetris -> Tetris
; moves a tick forward
(check-expect (tock tetris0-drop)
              tetris0-drop2)
(define (tock t)
  (if (landed? t) ; has the current block landed?
      (block-generate t) ; generate a new block
      (move t))) ; keep moving the current one

; Tetris -> Boolean
; checks if a tetris has landed
(define (landed? t)
  (or (ground? (tetris-block t)) (collide? t)))

; Block -> Boolean
; check if a block is on the ground
(check-expect (ground? (make-block 4 (- HEIGHT 1))) #true)
(check-expect (ground? (make-block 4 (- HEIGHT 2))) #false)
(define (ground? b)
  (= (block-y b)
     (sub1 HEIGHT)))

; Tetris -> Boolean
; check if the current dropping block collides with any others
(check-expect (collide? tetris0-land) #false) ; false, because the block has landed but not collided
(check-expect (collide? tetris-drop-on-block) #true)
(check-expect (collide? tetris0-drop) #false)
(define (collide? t)
  (member?
   (tetris-block (move t)) ; move the block once
   (tetris-landscape t))) ; and check collision

; Tetris -> Tetris
; updates the landscape and creates a new block
(define (block-generate t)
  (make-tetris
   (block-create (cons (tetris-block t) (tetris-landscape t)))
   ; list passed is blocks,
   ; that the new generated block cannot be on
   (cons (tetris-block t) (tetris-landscape t)))) ; placed block is added to landscape
  
; Block -> Block
; creates a new block
(define (block-create lob)
  (block-check-create
   lob (make-block (random WIDTH) 0)))
 
; List-of-blocks Block -> Block 
; generative recursion 
; checks if the block is not already in the list of positions
(define (block-check-create lob candidate)
  (if (member? candidate lob) (block-create lob) candidate))

; Tetris -> Tetris
; moves the current block forward one unit
(check-expect (move tetris0-drop)
              tetris0-drop2)
(define (move t)
  (make-tetris
   (make-block (block-x (tetris-block t))
               (add1 (block-y (tetris-block t)))) ; descends once
   (tetris-landscape t)))

; Tetris -> Boolean
; checks if the tetris has ended (block on top row)
(check-expect (end? tetris0-drop) #false)
(check-expect (end? tetris-over) #true)
(define (end? t)
  (end/l (tetris-landscape t)))

; Landscape -> Boolean
; checks if the tetris has ended (block on top row)
(define (end/l l)
  (cond
    [(empty? l) #false]
    [else
     (if (= (block-y (first l))
            0) ; y-pos of 0: at the very top
         #true
         (end/l (rest l)))]))
                

(define (tetris-main is)
  (big-bang is
    [on-tick tock 0.2]
    [on-key direct]
    [to-draw tetris-render]
    [stop-when end?]))