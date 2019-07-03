;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 094-sketch-ufo) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define WIDTH 100)
(define HEIGHT 100)
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

(define initial-scene (place-image UFO 50 5
                                   (place-image TANK 50 95 BG)))
(define ex1 (place-image UFO 40 5
                         (place-image MISSILE 30 30
                                      (place-image TANK 20 95 BG))))