;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 186-sorting-test) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; List-of-numbers -> Boolean
; check if a list is sorted
(check-expect (sorted>? (cons 1 '())) #true)
(check-expect (sorted>? (cons 2 (cons 1 '()))) #true)
(check-expect (sorted>? (cons 1 (cons 2 '()))) #false)
(define (sorted>? ne-l)
  (cond
    [(empty? (rest ne-l)) #true]
    [else (and (> (first ne-l) (first (rest ne-l)))
               (sorted>? (rest ne-l)))]))

; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(define (sort>/bad l)
  (list 9 8 7 6 5 4 3 2 1 0))

(check-expect (sort>/bad (list 3 1 2)) (list 1 2 3)) ; Checks correctly
(check-satisfied (sort>/bad (list 3 1 2)) sorted>?) ; Checks wrongly

;; Ex. 186: Can you formulate a test case that shows that sort>/bad is
;; not a sorting function? Can you use check-satisfied to formulate this test case?
; We can formulate a test case, but not with check-satisfied:
; the bad sort will always return a list which conforms to the sorted>? predicate,
; no matter what the input is.