;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 144-average-nelist) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Ex. 144: Will sum and how-many work for NEList-of-temperatures even
;; though they are designed for inputs from List-of-temperatures?
;; If you think they don’t work, provide counter-examples.
;; If you think they would, explain why.
; They will work, because the set of NEList-of-temperatures
; is smaller than the set of List-of-temperatures.
; All inputs that are in NEList-of-temperatures are in List-of-temperatures,
; so any functions that works with the latter works with the former.