;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 057-different-height) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 300) ; distances in pixels 
(define WIDTH  100)
(define YDELTA 3)
 
(define BACKG  (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))
 
(define CENTER (/ (image-height ROCKET) 2))

; An LRCD (for launching rocket countdown) is one of:
; – "resting"
; – a Number between -3 and -1
; – a NonnegativeNumber 
; interpretation a grounded rocket, in countdown mode,
; a number denotes the number of pixels between the
; top of the canvas and the rocket (its height)


; NonnegativeNumber -> Image
; gives an image of a rocket given an height
(check-expect
 (place-rocket 0)
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))
(check-expect
 (place-rocket 53)
 (place-image ROCKET 10 (- (- HEIGHT 53) CENTER) BACKG))

(define (place-rocket x)
  (place-image ROCKET 10 (- (- HEIGHT x) CENTER) BACKG))


; LRCD -> Image
; renders the state as a resting or flying rocket
(check-expect
 (show "resting")
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))
(check-expect
 (show -2)
 (place-image (text "-2" 20 "red")
              10 (* 3/4 WIDTH)
              (place-image ROCKET 10 (- 0 CENTER) BACKG)))
(check-expect
 (show HEIGHT)
 (place-image ROCKET 10 (- 0 CENTER) BACKG))
(check-expect
 (show 53)
 (place-image ROCKET 10 (- (- HEIGHT 53) CENTER) BACKG))
(check-expect
 (show 0)
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(define (show x)
  (cond
    [(string? x) ; First class: all strings equal to "resting" (enumeration)
     (place-rocket 0)]
    [(<= -3 x -1) ; Second class: all negative numbers [-3, -1] (enumeration)
     (place-image (text (number->string x) 20 "red")
                  10 (* 3/4 WIDTH)
                  (place-rocket HEIGHT))]
    [(>= x 0) ; Third class: all positive numbers (interval)
      (place-rocket x)]))


; LRCD KeyEvent -> LRCD
; starts the countdown when space bar is pressed, 
; if the rocket is still resting
(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)

(define (launch x ke)
  (cond
    [(string? x) (if (string=? " " ke) -3 x)]
    [(<= -3 x -1) x]
    [(>= x 0) x]))


; LRCD -> LRCD
; raises the rocket by YDELTA if it is moving already 
 
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) 0)
(check-expect (fly 10) (+ 10 YDELTA))
(check-expect (fly 22) (+ 22 YDELTA))
 
(define (fly x)
  (cond
    [(string? x) x]
    [(<= -3 x -1) (if (= x -1) 0 (+ x 1))]
    [(>= x 0) (+ x YDELTA)]))

; LRCD -> LRCD
; stops the ascent when the rocket has finished liftoff
(check-expect (stop "resting") #false)
(check-expect (stop -3) #false)
(check-expect (stop -1) #false)
(check-expect (stop HEIGHT) #true)
(check-expect (stop 0) #false)

(define (stop x)
  (cond
    [(number? x) (if (= x HEIGHT) #true #false)]
    [else #false]))

; LRCD -> LRCD
(define (main2 s)
  (big-bang s
    [to-draw show]
    [on-tick fly 0.1]
    [on-key launch]
    [stop-when stop]))

;; Ex. 57: Compare and contrast the solutions.
; Using HEIGHT in the other definition required a complete refactoring
; of the program. However, the readability gained is little,
; as seen in place-rocket.
; With a well-thought out data definition, like the second one, we avoid
; a lot of complexity when writing the program.