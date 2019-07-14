;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 148-should-you-work-with-empty-lists) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Ex. 148: Is it better to work with data definitions that accommodate
;; empty lists as opposed to definitions for non-empty lists?
; There is an advantage to both.
;
; In the case of definitions with empty lists, definition is simpler,
; but accomodating the case of the empty list has to be done with a check,
; which is more work later on.
;
; With definitions without empty lists, the domain is reduced,
; but at the cost of additional complexity in reasoning,
; and for readers of the code, too.