;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 009-in-with-ifs) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define in #true)

(if (string? in)
    (string-length in)
    (if (image? in)
        (* (image-height in) (image-width in))
        (if (number? in)
            (if (> in 0)
                (- in 1)
                in)
            (if in ;works because (if in 20 10) evaluates to (if #true 20 10) and #true is 20
                20
                10)))) ; similarly, #false is 10