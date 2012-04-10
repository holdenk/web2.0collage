#lang scheme

(define (render-page contet)
  (include-template "tmpl.html")
)

(define (render-with-wait waitingfor jsto)
  (include-template "wait.html")
)
(define (render-shirt-page imgurl)
  (include-template "shirt.html")
)