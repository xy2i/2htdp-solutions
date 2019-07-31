;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 201-select-all-album-titles) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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