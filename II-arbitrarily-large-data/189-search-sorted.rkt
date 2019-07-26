;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 189-search-sorted) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Number List-of-numbers -> Boolean
; searches for a number in a sorted list
(check-expect (search 2 (list 1 3 4 6 8 10 12 14 16)) #false)
(check-expect (search 5 (list 1 3 5 7 9)) #true)
(define (search-sorted n alon)
  (cond
    [(empty? alon) #false]
    [else
     (if (< n (first alon))
         #false
         (or (= (first alon) n)
             (search-sorted n (rest alon))))]))