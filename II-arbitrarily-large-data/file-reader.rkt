;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname file-reader) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

; A List-of-string is one of:
; - '()
; - (cons String List-of-string)
(cons "TTT" (cons "Put" (cons "up" (cons "in" (cons "a" (cons "place" (cons "where" (cons "it's" (cons "easy" (cons "to" (cons "see" (cons "the" (cons "cryptic" (cons "admonishement" (cons "T.T.T." (cons "When" (cons "you" (cons "feel" (cons "how" (cons "depressingly" (cons "slowly" (cons "you" (cons "climb," (cons "it's" (cons "well" (cons "to" (cons "remember" (cons "that" (cons "Things" (cons "Take" (cons "Time." (cons "Piet" (cons "Hein" '())))))))))))))))))))))))))))))))))

; A List-of-list-of-string is one of:
; - '()
; - (cons List-of-string List-of-list-of-string)
(define a (cons (cons "TTT" '())
                (cons '()
                      (cons (cons "Put" (cons "up" (cons "in" (cons "a" (cons "place" '())))))
                            (cons (cons "where" (cons "it's" (cons "easy" (cons "to" (cons "see" '())))))
                                  (cons (cons "the" (cons "cryptic" (cons "admonishment" '())))
                                        (cons (cons "T.T.T." '())
                                              (cons '()
                                                    (cons (cons "When" (cons "you" (cons "feel" (cons "how" (cons "depressingly" '())))))
                                                          (cons (cons "slowly" (cons "you" (cons "climb," '())))
                                                                (cons (cons "it's" (cons "well" (cons "to" (cons "remember" (cons "that" '())))))
                                                                      (cons (cons "Things" (cons "Take" (cons "Time." '())))
                                                                            (cons '()
                                                                                  (cons (cons "Piet" (cons "Hein" '()))
                                                                                        '()))))))))))))))

; LLS -> List-of-numbers
; determines the number of words on each line
(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))
(check-expect (words-on-line lls0) '())
(check-expect (words-on-line lls1)
              (cons 2 (cons 0 '())))

(define (words-on-line lls)
  (cond
    [(empty? lls) '()]
    [else
     (cons (words# (first lls)) ; a list of strings 
           (words-on-line (rest lls)))]))

; processes for each line
(define (words# ln)
  (length ln))

; String -> List-of-numbers
; counts the words on each line in the given file
(define (file-statistic file-name)
  (words-on-line
    (read-words/line file-name)))

(check-expect (read-words/line "ttt.txt") a)