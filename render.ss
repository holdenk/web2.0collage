#lang scheme
(require web-server/templates)
(provide (all-defined-out))
(define (render-page  content st bdl morehead)
  (list #"text/html" (include-template "tmpl.html"))
)

(define (render-with-wait waitingfor name jsto to flist)
  (render-page  (include-template "wait.html") (string-append waitingfor name) "onload=\"start();\"" (myjslist jsto) )
)

(define (render-shirt moretitle mylisto shirtimgurl) 
  (render-page  (include-template "shirt.html") moretitle "" (list ) )
  )

(define (jsmo jsloc)
  (include-template "jsloc")
  )

(define (myjslist jsto)
  (foldr string-append "" (map jsmo jsto))
  )

;;(define (render-shirt-page imgurl)
;;  (render-page (include-template "shirt.html") "- finished collage & shirt" "")
;)