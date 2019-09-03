;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 234-make-ranking) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define one-list
  '("Asia: Heat of the Moment"
    "U2: One"
    "The White Stripes: Seven Nation Army"))

; List-of-Strings -> nested list
; create a ordered rank for the list
(define (ranking los)
  (reverse (add-ranks (reverse los))))

; List-of-Strings -> nested list
; create a reverse rdered rank for the list
(define (add-ranks los)
  (cond
    [(empty? los) '()]
    [else (cons (list (length los) (first los))x
                (add-ranks (rest los)))]))

; List-of-list-of-string -> nested list
; create a table from a ranked list
(define (make-table l)
  `(table ((border "1"))
          ,(make-rows (ranking l))))

; List-of-list-of-String -> nested list
; create each row of a table, without heading
(define (make-rows l)
  (cond
    [(empty? l) '()]
    [else (cons (make-row (first l))
                (make-rows (rest l)))]))

; List-of-numbers -> ... nested list ...
; creates a row for a ranked list
(define (make-row l)
  `(tr
    ,(make-number-cell (first l))
    ,(make-string-cell (second l))))
 
; Number -> ... nested list ...
; creates a cell for an HTML table from a number 
(define (make-number-cell n)
  `(td ,(number->string n)))

; String -> ... nested list ...
; creates a cell for an HTML table from a number 
(define (make-string-cell s)
  `(td ,s))