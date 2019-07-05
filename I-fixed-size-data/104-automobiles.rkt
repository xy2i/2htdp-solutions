;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 104-automobiles) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct vehicle [carry lp fc])
; A Vehicle is a Struct.
; interpretation (make-vehicle Number Number Number)
; describes a vehicle that can carry carry-p persons,
; has a license plate of lp and a fuel consuption of fc

(define (consume-vehicle v)
  (+ (vehicle-carry v) .. (vehicle-lp v) .. (vehicle-fc v)))