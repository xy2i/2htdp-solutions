;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 146-nelist-how-many) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An NEList-of-temperatures is one of: 
; – (cons CTemperature '())
; – (cons CTemperature NEList-of-temperatures)
; interpretation non-empty lists of Celsius temperatures

; NEList-of-temperatures -> Number
; computes the average temperature
(check-expect (average (cons 12 '()))
              12)
(check-expect (average (cons 2 (cons 4 '())))
              3)
(check-expect (average (cons 1 (cons 2 (cons 3 '()))))
              2)
(define (average ne-l)
  (/ (sum ne-l)
     (how-many ne-l)))

; NEList-of-temperatures -> Number 
; adds up the temperatures on the given list
(check-expect
 (sum (cons 1 (cons 2 (cons 3 '())))) 6)
(define (sum ne-l)
  (cond
    [(empty? (rest ne-l)) (first ne-l)]
    [else (+ (first ne-l) (sum (rest ne-l)))]))
 
; NEList-of-temperatures -> Number 
; counts the temperatures on the given list
(check-expect
 (how-many (cons 1 (cons 2 (cons 3 '())))) 3)
(define (how-many ne-l)
  (cond
    [(empty? (rest ne-l)) 1] ;; the list is (cons CTemperature '()), we have 1 element
    [else (+ (how-many (rest ne-l)) 1)]))

; NEList-of-temperatures -> Number 
; checks if the temperatures are sorted, in descending order 3>2>1>0...
(check-expect (sorted>? (cons 1 '())) #true)
(check-expect (sorted>? (cons 2 (cons 1 '()))) #true)
(check-expect (sorted>? (cons 1 (cons 2 '()))) #false)
(define (sorted>? ne-l)
  (cond
    [(empty? (rest ne-l)) #true]
    [else (and (> (first ne-l) (first (rest ne-l)))
               (sorted>? (rest ne-l)))]))