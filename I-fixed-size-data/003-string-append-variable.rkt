(define str "helloworld")
(define i 9)

(string-append
 (substring str 0 i)
 "_"
 (substring str i))
