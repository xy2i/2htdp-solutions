(define str "helloworld")
(define i 9)

(string-append
 (substring str 0 i)
 (substring str (+ i 1)))
