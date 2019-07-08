;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 109-kleene-fsm) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; State is one of:
; – AA
; – BB
; – DD 
; – ER      
(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")
(define ER "error, illegal key")

; State -> State
; renders a white rectangle indicating current progress
(check-expect (render AA) (rectangle 100 100 "solid" "white"))
(check-expect (render BB) (rectangle 100 100 "solid" "yellow"))
(check-expect (render DD) (rectangle 100 100 "solid" "green"))
(check-expect (render ER) (rectangle 100 100 "solid" "red"))
(define (render s)
  (rectangle 100 100 "solid"
             (cond [(string=? AA s) "white"]
                   [(string=? BB s) "yellow"]
                   [(string=? DD s) "green"]
                   [(string=? ER s) "red"])))

; KeyPress -> State
; transitions for state AA
(check-expect (trans/AA "a") BB)
(check-expect (trans/AA "b") ER)
(check-expect (trans/AA "c") ER)
(check-expect (trans/AA "d") ER)
(define (trans/AA k)
  (cond [(string=? k "a") BB]
        [else ER]))

; KeyPress -> State
; transitions for state BB
(check-expect (trans/BB "a") ER)
(check-expect (trans/BB "b") BB)
(check-expect (trans/BB "c") BB)
(check-expect (trans/BB "d") DD)
(define (trans/BB k)
  (cond [(string=? k "b") BB]
        [(string=? k "c") BB]
        [(string=? k "d") DD]
        [else ER]))

; State -> State
; transitions to another state based on a keypress
(check-expect (trans AA "a") (trans/AA "a"))
(check-expect (trans BB "a") (trans/BB "a"))
(define (trans s k)
  (cond [(string=? AA s) (trans/AA k)]
        [(string=? BB s) (trans/BB k)]
        [else s])) ; cannot transition from state DD or ER

(define is AA)
(define (main s)
   (big-bang s
     [to-draw render]
     [on-key trans]))