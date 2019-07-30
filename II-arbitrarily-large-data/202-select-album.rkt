;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 202-select-album) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/itunes)

(define date1 (create-date 1 1 1 0 0 0))
(define date2 (create-date 2019 7 29 9 56 32))
(define date3 (create-date 2000 1 1 6 0 30))
(define date4 (create-date 2000 1 2 6 0 30))

(define track1 (create-track "Bust-a-move!" "Yousuke Yasui" "Ginga Force" 364000 1 date1 127 date2))
(define track2 (create-track "Aeronaut" "Yousuke Yasui" "Ginga Force" 128000 2 date1 21 date4))
(define track3 (create-track "Radiance" "sanodg" "Ridge Racer" 72000 12 date2 2 date3))

(define ltrack1 (list track1 track2 track3))
(define ltrack2 (list track2 track3))
(define ltrack3 (list track1 track2 track1 track1))

; LTracks -> Number
; computes the total playing time for all tracks in the list
(check-expect (total-time ltrack1) 564000)
(check-expect (total-time ltrack2) 200000)
(define (total-time lt)
  (cond
    [(empty? lt) 0]
    [else (+ (track-time (first lt))
             (total-time (rest lt)))]))

; LTracks -> List-of-Strings
; gets all the album titles from the collection
(check-expect (select-all-album-titles ltrack1)
              (list "Bust-a-move!" "Aeronaut" "Radiance"))
(check-expect (select-all-album-titles ltrack3)
              (list "Bust-a-move!" "Aeronaut" "Bust-a-move!" "Bust-a-move!"))
(define (select-all-album-titles lt)
  (cond
    [(empty? lt) '()]
    [else (cons (track-name (first lt))
                (select-all-album-titles (rest lt)))]))

; List-of-String -> List-of-String
; creates a set of unique strings
(check-expect (create-set (list "hi" "there"))
              (list "hi" "there"))
(check-expect (create-set (list "hi" "there" "oh" "hi" "mr." "there"))
              (list "oh" "hi" "mr." "there"))
(define (create-set los)
  (cond
    [(empty? los) '()]
    [else
     (if (member? (first los) (rest los))
         (create-set (rest los))
         (cons (first los) (create-set (rest los))))]))

; LTracks -> List-of-Strings
; gets all the album titles from the collection, uniquely
(check-expect (select-album-titles/unique ltrack1)
              (list "Bust-a-move!" "Aeronaut" "Radiance"))
(check-expect (select-album-titles/unique ltrack3)
              (list "Aeronaut" "Bust-a-move!"))
(define (select-album-titles/unique lt)
  (create-set (select-all-album-titles lt)))

; String LTracks -> LTracks
; extracts the list of tracks belonging to a given album
(check-expect (select-album "Ginga Force" ltrack1)
              (list track1 track2))
(check-expect (select-album "Ridge Racer" ltrack1)
              (list track3))
(check-expect (select-album "Yousuke" ltrack1)
              '())
(define (select-album album-name lt)
  (cond
    [(empty? lt) '()]
    [else
     (if (string=? (track-album (first lt)) album-name)
         (cons (first lt) (select-album album-name (rest lt)))
         (select-album album-name (rest lt)))]))