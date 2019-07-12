;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 134-contains) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A List-of-names is one of: 
; – '()
; – (cons String List-of-names)
; interpretation a list of invitees, by last name

; List-of-names -> Boolean
; determines whether "Flatt" is on a-list-of-names
(check-expect (contains? "a" '()) #false)
(check-expect (contains? "Flatt" (cons "Find" '()))
              #false)
(check-expect (contains? "Flatt" (cons "Flatt" '()))
              #true)
(check-expect
  (contains? "A" (cons "X" (cons "Y"  (cons "Z" '()))))
  #false)
(check-expect
  (contains? "Flatt"
    (cons "A" (cons "Flatt" (cons "C" '()))))
  #true)

(define (contains? e alon)
  (cond
    [(empty? alon) #false]
    [(cons? alon)
     (cond
      [(string=? (first alon) e) #true]
      [else (contains? e (rest alon))])]))