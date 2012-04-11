#lang scheme
(require web-server/templates)
(require (planet dherman/json:1:2/json)) ;;Used for json
(require net/url)
(provide (all-defined-out))
(define (render-page  content st bdl morehead)
  (list #"text/html" (include-template "tmpl.html"))
)

(define (render-with-wait waitingfor name jsto to flist [total 1])
  (render-page  (include-template "wait.html") 
		(string-append waitingfor name) 
		"onload=\"start();\"" 
		(myjslist jsto) )
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


;;Renders the JSON
(define (jt nexturl eleft)
	(define myport (open-output-string ))	
	(write (list nexturl eleft "test") myport )
	(get-output-string myport)
)
(define (render-json-wait nexturl eleft)
	;;This means the client has to know the position
	;;Less effort
	(define tehstr (jt nexturl eleft))
	(list #"text/javascript" tehstr )
)