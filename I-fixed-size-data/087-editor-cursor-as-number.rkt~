;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 087-editor-cursor-as-number) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define-struct editor [text loc])
; An Editor is a structure:
;   (make-editor String Number)
; interpretation (make-editor s c) describes an editor
; whose visible text is s with 
; the cursor displayed at position c
(define editor1 (make-editor "hello world" 11))
(define editor2 (make-editor "hello world!" 12))

(define SCN-WIDTH 200)
(define SCN (empty-scene SCN-WIDTH 20))
(define CURSOR (rectangle 1 20 "solid" "red"))

; Editor -> Image
; renders the text
(check-expect (render-text editor1)
              (beside (text "hello world" 11 "black")
                      CURSOR
                      (text "" 11 "black")))
(define (render-text e)
  (beside (text
           (substring (editor-text e) 0 (editor-loc e))
           11 "black")
          CURSOR
          (text
           (substring (editor-text e) (editor-loc e) (string-length (editor-text e)))
           11 "black")))

; Editor -> Image
; render the editor
(check-expect (render editor1)
              (overlay/align "left" "center"
                             (beside (text "hello world" 11 "black")
                                     CURSOR
                                     (text "" 11 "black"))
                             SCN))
(define (render e)
  (overlay/align "left" "center"
                 (render-text e)
                 SCN))

; String -> String
; returns a new string with the letter inserted at i
(check-expect (insert-letter "" "a" 0) "a")
(check-expect (insert-letter "abcde" "o" 1) "aobcde")
(define (insert-letter str ltr i)
  (string-append (substring str 0 i)
                 ltr
                 (substring str i (string-length str))))

; String -> String
; makes a new string with the letter at i removed,
; based on the position of a cursor
(check-expect (take-letter "abcde" 2) "acde")
(check-expect (take-letter "a" 1) "")
(check-expect (take-letter "" 1) "")
(define (take-letter str i)
  (cond
    [(string=? str "") ""]
    [(= i 0) str]
    [else (string-append
           (substring str 0 (sub1 i))
           (substring str i))]))

; Editor -> Number
; moves the position of a cursor, which cannot go beyond 0
(check-expect (cursor-left (make-editor "abcd" 4)) 3)
(check-expect (cursor-left (make-editor "abcd" 0)) 0)
(define (cursor-left e)
  (cond
    [(= (editor-loc e) 0) (editor-loc e)]
    [else (sub1 (editor-loc e))]))

; Editor -> Number
; moves the position of a cursor, which cannot go beyond the string's length
(check-expect (cursor-right (make-editor "abcd" 3)) 4)
(check-expect (cursor-right (make-editor "abcd" 4)) 4)
(define (cursor-right e)
  (cond
    [(= (editor-loc e)
        (string-length (editor-text e)))
     (editor-loc e)]
    [else (add1 (editor-loc e))]))

; Editor Editor -> Editor
; if the first editor passed is too large, returns the second editor,
; otherwhise the first
(check-expect (editor-large? (make-editor "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaan" 33)
                             (make-editor "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaann" 34))
              (make-editor "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaan" 33))
(check-expect (editor-large? (make-editor "abc" 2) (make-editor "abbc" 3))
              (make-editor "abbc" 3))
(define (editor-large? epre epost)
  (if (> (image-width (render-text epost))
         SCN-WIDTH) ; Editor is too big...
      epre ; so give back the initial one
      epost))

; Editor KeyEvent -> Editor
; create a new editor with the modified text
(check-expect (edit editor1 "!") editor2)
(check-expect (edit (make-editor "" 0) "o") (make-editor "o" 1))
(check-expect (edit (make-editor " " 1) " ") (make-editor "  " 2))
(check-expect (edit editor2 "\b") editor1)
(check-expect (edit (make-editor "" 0) "\b") (make-editor "" 0))
(check-expect (edit (make-editor "o" 0) "\b") (make-editor "o" 0))
(check-expect (edit (make-editor "a" 0) "\t") (make-editor "a" 0))
(check-expect (edit (make-editor "a" 0) "\r") (make-editor "a" 0))
(check-expect (edit (make-editor "abc" 2) "left") (make-editor "abc" 1))
(check-expect (edit (make-editor "abcd" 4) "left") (make-editor "abcd" 3))
(check-expect (edit (make-editor "a" 1) "left") (make-editor "a" 0))
(check-expect (edit (make-editor "" 0) "left") (make-editor "" 0))
(check-expect (edit (make-editor "abc" 2) "right") (make-editor "abc" 3))
(check-expect (edit (make-editor "ab" 2) "right") (make-editor "ab" 2))
(check-expect (edit (make-editor "aaabc" 3) "right") (make-editor "aaabc" 4))
(check-expect (edit (make-editor "" 0) "right") (make-editor "" 0))

(define (edit e ke)
  ; this whole cond expressions returns an editor,
  ; we check if it is too large with editor-large
  ; and give the initial editor e if so
  (editor-large? e
                 (cond
                   [(string=? ke "\t") e]
                   [(string=? ke "\r") e]
                   [(string=? ke "\b")
                    (make-editor
                     (take-letter (editor-text e) (editor-loc e))
                     (cursor-left e))]
                   [(string=? ke "left")
                    (make-editor
                     (editor-text e)
                     (cursor-left e))]
                   [(string=? ke "right")
                    (make-editor
                     (editor-text e)
                     (cursor-right e))]
                   ; intercept all other presses
                   [else
                    (make-editor
                     (insert-letter (editor-text e) ke (editor-loc e))
                     (add1 (editor-loc e)))])))

; Editor -> Editor
(define (run e)
  (big-bang e
    [to-draw render]
    [on-key edit]))

;; Conclusion
; The choice of data representation impacts largely on the design
; of the entire program.
; With a representation with a string and a cursor position, designing
; the rest of the program was much harder, even if it seemed
; more convenient at a first glance.