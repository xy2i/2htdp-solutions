;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 088-vcat) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct vcat [x hv])
; A VCat is a structure.
; interpretation (make-vcat x happiness-value)
; makes a cat with its position at x
; with an happiness of happiness-value