;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 229-ktransition) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

; An FSM is one of:
;   – '()
;   – (cons Transition FSM)
 
(define-struct ktransition [current key next])
; A Transition.v2 is a structure:
;   (make-ktransition FSM-State KeyEvent FSM-State)
 
; FSM-State is a Color.
 
; interpretation An FSM represents the transitions that a
; finite state machine can take from one state to another 
; in reaction to keystrokes

(define fsm-abcd
  (list
   (make-ktransition "red" "a" "yellow")
   (make-ktransition "yellow" "b" "yellow")
   (make-ktransition "yellow" "c" "yellow")
   (make-ktransition "yellow" "d" "green")))
   

; State -> Boolean
; determines whether s is a state
(check-expect (state? "red") #true)
(check-expect (state? "green") #true)
(check-expect (state? "yellow") #true)
(check-expect (state? "banana") #false)
(define (state? s)
  (image-color? s))



(define-struct fs [fsm current])
; A SimulationState.v2 is a structure: 
;   (make-fs FSM FSM-State)

; SimulationState.v2 -> Image 
; renders current world state as a colored square 
(check-expect (state-as-colored-square
                (make-fs fsm-abcd "red"))
              (square 100 "solid" "red"))
 
(define (state-as-colored-square an-fsm)
  (square 100 "solid" (fs-current an-fsm)))
     
; SimulationState.v2 KeyEvent -> SimulationState.v2
; finds the next state from ke and cs
(check-expect
  (find-next-state (make-fs fsm-abcd "red") "a")
  (make-fs fsm-abcd "yellow"))
(check-expect
  (find-next-state (make-fs fsm-abcd "yellow") "b")
  (make-fs fsm-abcd "yellow"))
(check-expect
  (find-next-state (make-fs fsm-abcd "yellow") "d")
  (make-fs fsm-abcd "green"))
(define (find-next-state an-fsm ke)
  (make-fs
    (fs-fsm an-fsm)
    (find (fs-fsm an-fsm) (fs-current an-fsm) ke)))

; FSM FSM-State -> FSM-State
; finds the state representing current in transitions
; and retrieves the next field 
(check-expect (find fsm-abcd "red" "a") "yellow")
(check-expect (find fsm-abcd "yellow" "d") "green")
(check-error (find fsm-abcd "black" "a")
             "not found: black")
(define (find transitions current ke)
  (cond
    [(empty? transitions) (error (string-append "not found: " current))]
    [else
     (if (and
          ; is the first's transition current state the same as ours?
          (string=? (ktransition-current (first transitions)) current)
          ; is the key to transition correct?
          (string=? (ktransition-key (first transitions)) ke))
         (ktransition-next (first transitions)) ; found
         (find (rest transitions) current ke))])) ; not found

; FSM FSM-State -> SimulationState.v2 
; match the keys pressed with the given FSM
(define (simulate.v2 an-fsm s0)
  (big-bang (make-fs an-fsm s0)
    [to-draw state-as-colored-square]
    [on-key find-next-state]))