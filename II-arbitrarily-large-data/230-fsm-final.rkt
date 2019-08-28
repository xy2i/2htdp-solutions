;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 230-fsm-final) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

; An FSM is one of:
;   – '()
;   – (cons Transition FSM)
 
(define-struct fsm [initial transitions final])
(define-struct transition [current key next])
; An FSM.v2 is a structure: 
;   (make-fsm FSM-State LOT FSM-State)
; A LOT is one of: 
; – '() 
; – (cons Transition.v3 LOT)
; A Transition.v3 is a structure: 
;   (make-transition FSM-State KeyEvent FSM-State)

(define fsm-abcd
  (make-fsm
   "red"
   (list
    (make-transition "red" "a" "yellow")
    (make-transition "yellow" "b" "yellow")
    (make-transition "yellow" "c" "yellow")
    (make-transition "yellow" "d" "green"))
   "green"))

; State -> Boolean
; determines whether s is a state
(check-expect (state? "red") #true)
(check-expect (state? "green") #true)
(check-expect (state? "yellow") #true)
(check-expect (state? "banana") #false)
(define (state? s)
  (image-color? s))


; SimulationState.v2 -> Image 
; renders current world state as a colored square 
(check-expect (state-as-colored-square fsm-abcd)
              (square 100 "solid" "red"))
 
(define (state-as-colored-square an-fsm)
  (square 100 "solid" (fsm-initial an-fsm)))
     
; SimulationState.v2 KeyEvent -> SimulationState.v2
; finds the next state from ke and cs
(check-expect
  (find-next-state fsm-abcd "a")
  (make-fsm
   "yellow"
   (fsm-transitions fsm-abcd)
   (fsm-final fsm-abcd)))
(define (find-next-state an-fsm ke)
  (make-fsm
   (find (fsm-transitions an-fsm) (fsm-initial an-fsm) ke)
   (fsm-transitions an-fsm)
   (fsm-final an-fsm)))

; FSM FSM-State -> FSM-State
; finds the state representing current in transitions
; and retrieves the next field 
(check-expect (find (fsm-transitions fsm-abcd) "red" "a") "yellow")
(check-expect (find (fsm-transitions fsm-abcd) "yellow" "d") "green")
(check-error (find (fsm-transitions fsm-abcd) "black" "a")
             "not found: black")
(define (find transitions current ke)
  (cond
    [(empty? transitions) (error (string-append "not found: " current))]
    [else
     (if (and
          ; is the first's transition current state the same as ours?
          (string=? (transition-current (first transitions)) current)
          ; is the key to transition correct?
          (string=? (transition-key (first transitions)) ke))
         (transition-next (first transitions)) ; found
         (find (rest transitions) current ke))])) ; not found

(define (final-state? fsm)
  (string=? (fsm-initial fsm) (fsm-final fsm)))

; FSM FSM-State -> SimulationState.v2 
; match the keys pressed with the given FSM
(define (simulate.v2 an-fsm)
  (big-bang an-fsm
    [to-draw state-as-colored-square]
    [on-key find-next-state]
    [stop-when final-state?]))