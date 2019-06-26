;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 049-nested-cond) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define y 210)
(- 200 (cond [(> y 200) 0] [else y]))

; Original
(define (create-rocket-scene.v5 h)
  (cond
    [(<= h ROCKET-CENTER-TO-TOP)
     (place-image ROCKET 50 h MTSCN)]
    [(> h ROCKET-CENTER-TO-TOP)
     (place-image ROCKET 50 ROCKET-CENTER-TO-TOP MTSCN)]))

; Nested cond
(define (create-rocket-scene-nested.v5 h)
     (place-image ROCKET
                  50
                  (cond
                    [(<= h ROCKET-CENTER-TO-TOP) h]
                    [(> h ROCKET-CENTER-TO-TOP) ROCKET-CENTER-TO-TOP])
                  MTSCN)