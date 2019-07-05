;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 103-data-definitions-for-animals) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Spider is a struct.
; interpretation (make-spider Number Number )
; makes a spider with num-of-legs legs and a size
; of size
(define-struct spider [size legs])

; A Elephant is a Number.
; interpretation the size of the elephant

; A Boa is a struct.
; interpretation (make-boa Number Number)
; makes a spider with a size of size and
; a girth of girth
(define-struct boa [size g])

; A Armadillo is a struct.
; interpretation (make-armadillo Number Boolean)
; makes an armadillo with a size and that is armored or not
(define struct armadillo [size shelled])