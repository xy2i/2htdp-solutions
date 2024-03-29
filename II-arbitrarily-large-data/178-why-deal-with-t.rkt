;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 178-why-deal-with-t) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define HEIGHT 20) ; the height of the editor 
(define WIDTH 200) ; its width 
(define FONT-SIZE 16) ; the font size 
(define FONT-COLOR "black") ; the font color 
 
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor Lo1S Lo1S) 
; An Lo1S is one of: 
; – '()
; – (cons 1String Lo1S)

(define good
  (cons "g" (cons "o" (cons "o" (cons "d" '())))))
(define all
  (cons "a" (cons "l" (cons "l" '()))))
(define lla
  (cons "l" (cons "l" (cons "a" '()))))
 
(check-expect (create-editor "lla" "good")
              (make-editor all good))
(check-expect (create-editor "all" "good")
              (make-editor lla good))

(define (create-editor pre post)
  (make-editor (reverse (explode pre))
               (explode post)))

; Editor -> Image
; renders an editor as an image of the two texts 
; separated by the cursor 
(define (editor-render e) MT)
 
; Editor KeyEvent -> Editor
; deals with a key event, given some editor
(check-expect
 (editor-kh (create-editor "" "") "e")
 (create-editor "e" ""))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "e")
 (create-editor "cde" "fgh"))
(check-expect
 (editor-kh (create-editor "abc" "") "e")
 (create-editor "abce" ""))
(check-expect
 (editor-kh (create-editor "" "fg") "e")
 (create-editor "e" "fg"))
(check-expect
 (editor-kh (create-editor "a" "") "\b")
 (create-editor "" ""))
(check-expect
 (editor-kh (create-editor "a" "bcd") "\b")
 (create-editor "" "bcd"))
(check-expect
 (editor-kh (create-editor "abc" "def") "\b")
 (create-editor "ab" "def"))
(check-expect
 (editor-kh (create-editor "abc" "") "\b")
 (create-editor "ab" ""))
(check-expect
 (editor-kh (create-editor "abc" "") "right")
 (create-editor "abc" ""))
(check-expect
 (editor-kh (create-editor "abc" "def") "right")
 (create-editor "abcd" "ef"))
(check-expect
 (editor-kh (create-editor "" "def") "right")
 (create-editor "d" "ef"))
(check-expect
 (editor-kh (create-editor "" "") "right")
 (create-editor "" ""))
(check-expect
 (editor-kh (create-editor "abc" "") "left")
 (create-editor "ab" "c"))
(check-expect
 (editor-kh (create-editor "abc" "def") "left")
 (create-editor "ab" "cdef"))
(check-expect
 (editor-kh (create-editor "" "def") "left")
 (create-editor "" "def"))
(check-expect
 (editor-kh (create-editor "" "") "left")
 (create-editor "" ""))

(define (editor-kh ed k)
  (cond
    [(key=? k "left") ...]
    [(key=? k "right") ...]
    [(key=? k "\b") ...]
    [(key=? k "\t") ...]
    [(key=? k "\r") ...]
    [(= (string-length k) 1) ...]
    [else ...]))

;; Ex. 178: Why deal with \t before checking for strings of length 1?
; \b, \t and \r are the only special KeyEvents whose length is equal to 1.
; If we do not check for them now, they will be caught by th
; (= (string-length k) 1) clause.