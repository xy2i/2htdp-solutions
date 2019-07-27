;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 193a-render-poly-ideas) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Ex. 193: render-poly could cons the last item of p onto p and then call connect-dots.

(require 2htdp/image)

; An NELoP is one of: 
; – (cons Posn '())
; – (cons Posn NELoP)

; a plain background image 
(define MT (empty-scene 50 50))
(define triangle-p
  (list
   (make-posn 20 10)
   (make-posn 20 20)
   (make-posn 30 20)))   	
(define square-p
  (list
   (make-posn 10 10)
   (make-posn 20 10)
   (make-posn 20 20)
   (make-posn 10 20)))

(check-expect (connect-dots MT triangle-p)
              (scene+line
               (scene+line MT 20 10 20 20 "red")
               20 20 30 20 "red"))

(check-expect (connect-dots MT square-p)
              (scene+line
               (scene+line
                (scene+line MT 10 10 20 10 "red")
                20 10 20 20 "red")
               20 20 10 20 "red"))
; Image NELoP -> Image 
; connects the dots in p by rendering lines in img
(define (connect-dots img p)
  (cond
    [(empty? (rest p)) MT]
    [else
     (render-line
       (connect-dots img (rest p))
       (first p)
       (second p))]))

; Image Posn Posn -> Image 
; renders a line from p to q into img
(check-expect (render-line MT (make-posn 0 0) (make-posn 50 50))
              (scene+line MT 0 0 50 50 "red"))
(define (render-line img p q)
  (scene+line
    img
    (posn-x p) (posn-y p) (posn-x q) (posn-y q)
    "red"))

; Image Polygon -> Image 
; adds an image of p to img
(check-expect
  (render-poly MT triangle-p)
  (scene+line
    (scene+line
      (scene+line MT 20 10 20 20 "red")
      20 20 30 20 "red")
    30 20 20 10 "red"))
(check-expect
  (render-poly MT square-p)
  (scene+line
    (scene+line
      (scene+line
        (scene+line MT 10 10 20 10 "red")
        20 10 20 20 "red")
      20 20 10 20 "red")
    10 20 10 10 "red"))

(define (render-poly img p)
  (connect-dots img (cons (last p) ; cons the last point, so that we start drawing from the last
                          p)))

; NELoP -> Posn
; extracts the last item from p
(check-expect (last (list (make-posn 1 2) (make-posn 3 4) (make-posn 0 0)))
              (make-posn 0 0))
(check-expect (last (list (make-posn 1 2)))
              (make-posn 1 2))
(define (last p)
  (cond
    [(empty? (rest p)) (first p)]
    [else (last (rest p))]))