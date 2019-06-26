;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 030-refactoring) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define base-ticket-price 5.0)
(define base-people 120)
(define variable-ticket-price 0.1)
(define people-ticket-price 15)

(define price-sensitivity
  (/ people-ticket-price variable-ticket-price))

(define (attendees ticket-price)
  (- base-people (* (- ticket-price base-ticket-price) price-sensitivity)))

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define variable-cost 0.04)

(define (cost ticket-price)
  (* variable-cost (attendees ticket-price)))

(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(profit 3)