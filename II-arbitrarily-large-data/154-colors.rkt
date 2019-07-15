;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 154-colors) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define-struct layer [color doll])
; An RD (short for Russian doll) is one of: 
; – String 
; – (make-layer String RD)

(define BASE-SIZE 32)
(define CIRCLE-S (/ BASE-SIZE 8))

(check-expect (draw-doll 1 "red")
              (overlay/align "middle" "top"
                             (circle 4 "solid" "red")
                             (isosceles-triangle 32 40 "solid" "red")))
(define (draw-doll level color)
  (overlay/align "middle" "top"
                 (circle (* level CIRCLE-S) "solid" color)
                 (isosceles-triangle (* level BASE-SIZE) 40 "solid" color)))

; RD -> Number
; how many dolls are a part of an-rd
(check-expect (depth "red") 1)
(check-expect
  (depth
   (make-layer "yellow" (make-layer "green" "red")))
  3)
(define (depth an-rd)
  (cond
    [(string? an-rd) 1]
    [else (+ (depth (layer-doll an-rd)) 1)]))

; RD -> String
; creates a flat list of the dolls
(check-expect (colors (make-layer "yellow" (make-layer "green" "red"))) "yellow, green, red")
(define (colors an-rd)
  (cond
    [(string? an-rd) an-rd] ; one russian doll: it's itself, as in the string ("yellow")
    [(layer? an-rd)
     (string-append (layer-color an-rd)
                    ", "
                    (colors (layer-doll an-rd)))]))