;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 207-total-time-list) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/itunes)

(define date1 (create-date 1 1 1 0 0 0))
(define date2 (create-date 2019 7 29 9 56 32))
(define date3 (create-date 2000 1 1 6 0 30))
(define date4 (create-date 2000 1 2 6 0 30))
(define date5 (create-date 2005 1 1 6 0 30))

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
              (list
 "Ginga Force"
 "Ginga Force"
 "Ridge Racer"))
(check-expect (select-all-album-titles ltrack3)
              (list
 "Ginga Force"
 "Ginga Force"
 "Ginga Force"
 "Ginga Force"))
(define (select-all-album-titles lt)
  (cond
    [(empty? lt) '()]
    [else (cons (track-album (first lt))
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

; LTracks -> List-of-Strings
; gets all the album titles from the collection, uniquely
(check-expect (select-album-titles/unique ltrack1)
              (list "Ginga Force" "Ridge Racer"))
(check-expect (select-album-titles/unique ltrack3)
              (list "Ginga Force"))
(define (select-album-titles/unique lt)
  (create-set (select-all-album-titles lt)))

; String Date LTracks -> LTracks
; String LTracks -> LTracks
; extracts the list of tracks belonging to a given album, that have played after a date
(check-expect (select-album-date ltrack1 "Ginga Force" date5)
              (list track1))
(define (select-album-date lt aname date)
  (cond
    [(empty? lt) '()]
    [else
     (if (and (in-album? aname (first lt))
              (last-played-to-date? date (first lt)))
         (cons (first lt) (select-album-date (rest lt) aname date))
         (select-album-date (rest lt) aname date))]))

; String Track -> Boolean
; checks if a track is in the album
(define (in-album? aname track)
  (string=? (track-album track) aname))

; Date Track -> Boolean
; checks if a track has been last played at a later date than the given date
(define (last-played-to-date? date track)
  (greater-date<? date (track-played track)))

; compares two dates
; true if date1 < date2
(check-expect (greater-date<? date5 date4) #false)
(define (greater-date<? d1 d2)
  (cond [(< (date-year d1) (date-year d2)) #true]
        [(> (date-year d1) (date-year d2)) #false]
        [else
         (cond [(< (date-month d1) (date-month d2)) #true]
               [(> (date-month d1) (date-month d2)) #false]
               [else
                (cond [(< (date-day d1) (date-day d2)) #true]
                      [(> (date-day d1) (date-day d2)) #false]
                      [else
                       (cond [(< (date-hour d1) (date-hour d2)) #true]
                             [(> (date-hour d1) (date-hour d2)) #false]
                             [else
                              (cond [(< (date-minute d1) (date-minute d2)) #true]
                                    [(> (date-minute d1) (date-minute d2)) #false]
                                    [else
                                     (cond [(< (date-minute d1) (date-minute d2)) #true]
                                           [(> (date-minute d1) (date-minute d2)) #false]
                                           [else #false])])])])])]))


; LTracks -> List-of-LTracks
; makes a LTrack for each album of the list of tracks
(check-expect (select-albums ltrack1)
              (list (list track1 track2)
                    (list track3)))
(define (select-albums lt)
  (list-for-each-album (select-album-titles/unique lt) lt))

; LTracks String -> List-of-LTracks
; makes a LTrack for ecah album
(define (list-for-each-album atitles lt)
  (cond
    [(empty? atitles) '()]
    [else (cons (select-album (first atitles) lt)
                (list-for-each-album (rest atitles) lt))]))



; An LLists is one of:
; – '()
; – (cons LAssoc LLists)
 
; An LAssoc is one of: 
; – '()
; – (cons Association LAssoc)
; 
; An Association is a list of two items: 
;   (cons String (cons BSDN '()))
 
; A BSDN is one of: 
; – Boolean
; – Number
; – String
; – Date

(define lassoc1 (list (list "Hello" 1)
                      (list "world" #true)
                      (list "how" 23)))
(define lassoc2 (list (list "How_is_you" 42)
                      (list "secondary_key" (create-date 1 1 1 0 0 0))
                      (list "primary" "this is some really long text")
                      (list "another one" "Hello world!")))
(define lassoc3 (list (list "only one line" 1)))

(define llist1 (list lassoc1 lassoc2 lassoc3))
(define llist2 (list lassoc1 lassoc3 lassoc2 lassoc3 lassoc1))

; String LAssoc Any -> Any
; returns the corresponding item in the lassoc, or default if it is not found
(check-expect (find-association "world" lassoc1 #false)
              (list "world" #true))
(check-expect (find-association "secondary_key" lassoc2 42)
              (list "secondary_key" (create-date 1 1 1 0 0 0)))
(check-expect (find-association "doenst_exist_key" lassoc1 420)
              420)
(define (find-association key lassoc default)
  (cond
    [(empty? lassoc) default]
    [else
     (if (string=? (first (first lassoc)) ; key (left side) of first item
                   key)
         (first lassoc) ; return the assoc
         (find-association key (rest lassoc) default))])) ; keep searching otherwhise

; BSDN -> (list "label" BSDN)
(define (create-name str)
  (list "name" str))
(define (create-artist str)
  (list "artist" str))
(define (create-album str)
  (list "album" str))
(define (create-time num)
  (list "time" num))
(define (create-track# num)
  (list "track#" num))
(define (create-added dt)
  (list "added" dt))
(define (create-play# num)
  (list "play#" num))
(define (create-played dt)
(list "played" dt))

(define atrack1
  (list
   (create-name "Bust-a-move!")
   (create-artist "Yousuke Yasui")
   (create-album "Ginga Force")
   (create-time 36400)
   (create-track# 1)
   (create-added date1)
   (create-play# 127)
   (create-played date2)))
(define atrack2
  (list
   (create-track "Aeronaut")
   (create-artist "Yousuke Yasui")
   (create-album "Ginga Force")
   (create-time 128000)
   (create-track# 2)
   (create-added date1)
   (create-play# 21)
   (create-played date4)))
(define atrack3
  (list
   (create-name "Radiance")
   (create-artist "sanodg")
   (create-album "Ridge Racer")
   (create-time 72000)
   (create-track# 12)
   (create-added date2)
   (create-play# 2)
   (create-played date3)))

(define latrack1 (list atrack1 atrack2 atrack3))
(define latrack2 (list atrack2 atrack3))
(define latrack3 (list atrack1 atrack2 atrack1 atrack1))

; LList -> Number
; creates the total amount of play time
(define (total-time/list llist)