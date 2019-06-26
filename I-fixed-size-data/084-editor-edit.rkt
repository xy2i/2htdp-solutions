;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 084-editor-edit) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t
(define editor1 (make-editor "hello " "world"))
(define editor2 (make-editor "hello !" "world"))

(define SCN (empty-scene 200 20))
(define CURSOR (rectangle 1 20 "solid" "red"))

; Editor -> Image
; render the editor
(check-expect (render editor1)
              (overlay/align "left" "center"
                             (beside (text "hello " 11 "black")
                                     CURSOR
                                     (text "world" 11 "black"))
                             SCN))
(define (render e)
  (overlay/align "left" "center"
                 (beside (text (editor-pre e) 11 "black")
                         CURSOR
                         (text (editor-post e) 11 "black"))
                 SCN))

; String -> 1String
; produces the last character of a string
(check-expect (string-last "ab") "b")
(check-expect (string-last "") "")
(define (string-last str)
  (cond
    [(string=? str "") ""]
    [else (string-ith str (- (string-length str) 1))]))

; String -> String
; produces the first character of a string
(check-expect (string-first "ab") "a")
(check-expect (string-first "") "")
(define (string-first str)
  (cond
    [(string=? str "") ""]
    [else (string-ith str 0)]))

; String -> String
; produces the same string with the last character removed
(check-expect (string-rest "hello ") "ello ")
(check-expect (string-rest "") "")
(define (string-rest str)
  (cond
    [(string=? str "") ""] ; if the string is empty, it stays empty
    [else (substring str 1 (string-length str))]))

; String -> String
; produces the same string with the last character removed
(check-expect (string-remove-last "hello ") "hello")
(check-expect (string-remove-last "") "")
(define (string-remove-last str)
  (cond
    [(string=? str "") ""] ; if the string is empty, it stays empty
    [else (substring str 0 (- (string-length str) 1))]))

; Editor KeyEvent -> Editor
; create a new editor with the modified text
(check-expect (edit editor1 "!") editor2)
(check-expect (edit editor2 "\b") editor1)
(check-expect (edit (make-editor "" "") "\b") (make-editor "" ""))
(check-expect (edit (make-editor "a" "") "o") (make-editor "ao" ""))
(check-expect (edit (make-editor "" "") "o") (make-editor "o" ""))
(check-expect (edit (make-editor "" "") "") (make-editor "" ""))
(check-expect (edit (make-editor "a" "") "\t") (make-editor "a" ""))
(check-expect (edit (make-editor "a" "") "\r") (make-editor "a" ""))
(check-expect (edit (make-editor "ab" "c") "left") (make-editor "a" "bc"))
(check-expect (edit (make-editor "abcd" "") "left") (make-editor "abc" "d"))
(check-expect (edit (make-editor "a" "") "left") (make-editor "" "a"))
(check-expect (edit (make-editor "" "") "left") (make-editor "" ""))
(check-expect (edit (make-editor "ab" "c") "right") (make-editor "abc" ""))
(check-expect (edit (make-editor "ab" "") "right") (make-editor "ab" ""))
(check-expect (edit (make-editor "aaa" "bc") "right") (make-editor "aaab" "c"))
(check-expect (edit (make-editor "" "") "right") (make-editor "" ""))
(check-expect (edit (make-editor "" "") "shift") (make-editor "" ""))

(define (edit e ke)
  (cond
    [(string=? ke "\t") e] ; tab and carriage return do nothing
    [(string=? ke "\r") e]
    [(string=? ke "shift") e]
    [(string=? ke "\b")
     (make-editor
      (string-remove-last (editor-pre e))
      (editor-post e))]
    [(string=? ke "left")
     (make-editor
      (string-remove-last (editor-pre e))
      (string-append
       (string-last (editor-pre e)) (editor-post e)))]
    [(string=? ke "right")
     (make-editor
      (string-append (editor-pre e) (string-first (editor-post e)))
      (string-rest (editor-post e)))]
    [else
     (make-editor
      (string-append (editor-pre e) ke)
      (editor-post e))]))

; Editor -> Editor
(define (run e)
  (big-bang e
    [to-draw render]
    [on-key edit]))