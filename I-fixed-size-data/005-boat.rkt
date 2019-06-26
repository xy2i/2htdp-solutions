;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 005-boat) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define width 400)
(define height 200)

(define sea (rectangle width (/ height 10) "solid" "blue"))
(define base (rectangle (/ width 4) (/ height 5) "solid" "brown"))

(define mat (rectangle (/ width 32) height "solid" "brown"))
(define flag (right-triangle (/ width 8) (/ height 5) "solid" "red"))

; overlay/align takes multiple things and stacks them all at once
; sea -> base -> (flag -> mat)
(overlay/align "center" "bottom" sea base (overlay/align "left" "top" flag mat))