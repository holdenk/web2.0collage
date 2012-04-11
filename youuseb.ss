#lang web-server
;we need to parse some stuff
(require srfi/13)
(require srfi/14)
;we need to be awesome since fav icons need to be fetched
(require "fvico.ss")
;we need to construct a composite
(require "graphics.ss")
;;Where the templates are taken care of
(require "render.ss")
(define interface-version 'stateless)
(provide interface-version stuffer mystuffer start)
;;(provide (all-defined-out))
;;timeout pandas
;;How we serlialize our data
;;(define stuffer
;;   (stuffer-chain
;;    serialize-stuffer
;;    (md5-stuffer (build-path "/tmp/" ".urls"))))
;;(define mykb (bytes 65 112 112 108 101 255 254 12))
(define mystuffer   (stuffer-chain
   (stuffer-chain
   serialize-stuffer
;;   (HMAC-SHA1-stuffer mykb)
   base64-stuffer)
   is-url-too-big?
   (stuffer-chain
;;    (HMAC-SHA1-stuffer mykb)
    gzip-stuffer
    base64-stuffer)
   is-url-too-big?
   (md5-stuffer (build-path "/tmp/" ".urls3"))))
(define (start req)
  (phase-1 req))

(define (phase-1 request)
  (local [(define (response-generator make-url)
           (render-with-wait "Sniffing browser history for collage" " - phase 1" 
                              (list  "/js/prototype/prototype.js" "/js/bramus/jsProgressBarHandler.js" "/sitelist.js" "/hist.js") (url->string (make-url phase-2)) "") )]
    (send/suspend/url/dispatch response-generator)
  ))

(define (fixmyninja str)
	str;;do more later
)

(define (maketasteylist str)
(remove-duplicates (map fixmyninja
  (remove-duplicates (string-tokenize str (char-set-complement  char-set:whitespace )) )))
  )

(define (extracticourls ls)
    (findicourls ls)
  )

(define (phase-2 request)
  (local [(define (response-generator make-url)
            (render-with-wait 
	"Collecting favicon url" " - phase 2" 
        (list "/foo.js" "/js/prototype/prototype.js" "/js/bramus/jsProgressBarHandler.js") (url->string (make-url myphase-3))  (foldr string-append "fv:" fvlist)))
	(define bindings (request-bindings request))
	(define fvlist (maketasteylist 
		(cond 
                 ((exists-binding? 'sitelist bindings) 
			(extract-binding/single 'sitelist bindings))
                 (else "" )
                ) ))
	(define (myphase-3 request)
	(phase-3 fvlist 0 (list ) request))]
	(send/suspend/url/dispatch response-generator)	
  )
	
)

(define (firstn n l)
	(cond
	((= n 0) empty)
	((empty? l) empty)
	(else (cons (first l) (firstn (- n 1) (rest l) ) ))
	)
)
(define (aftern n l)
	(cond
	((empty? l) empty)
	((= n 0) l)
	(else (aftern (- n 1) (rest l) ) )
	)
)
(define (phase-3 fvlist n sfar request)
  (local (
          (define tl (firstn 1 fvlist))
	  (define rl (aftern 1 fvlist))
          )
    
  (local [(define (response-generator make-url)
            (render-with-wait  
		"Fetching icon for collage" 
		(string-append " - phase 3." 
				(number->string n) 
				", " 
				(number->string (length rl)) 
		"icons to go")
                (list 	"/jsfoo.js" ;;Uses js rather then referseh loop
			"/js/prototype/prototype.js" 
			"/js/bramus/jsProgressBarHandler.js")
		
		(url->string (make-url myphase-4))
                              (string-append 
				(foldr string-append "tl:" tl) 
				(string-append (foldr string-append "rl:" rl)
                                (foldr string-append "icob:" 
					(map url->string icos) )) ) 
		(length fvlist) ))
          ;;Don't extra icons yet
          (define icos
            sfar)
          
          ;;Implicitly capture the state. I love scheme
          (define (myphase-4 request)
	(phase-3.1 rl (+ 1 n )  icos request)
	)
          ]
    (send/suspend/url/dispatch response-generator))))

(define (phase-3.1 ufvlist n sfar request)
  (local (
	;;We allow the client to "skip" a certain number of URLs
	;;This is useful for some things which randomly timeout/die
        ;;We should probably keep this feature in the future, but
        ;;also finding out how net/uri time outs may reduce how often it 
        ;;needs to be used
	  (define mybindings (request-bindings request) )
	  (define skipcount (cond  
				((exists-binding? 'skipcount mybindings) 
				(string->number (extract-binding/single 'skipcount mybindings)) )
				(else 0) ))
	  (define fvlist (aftern skipcount ufvlist))
	;;End of the skip code
          (define tl (firstn 1 fvlist))
	  (define rl (aftern 1 fvlist))
          )
    
  (local [(define (response-generator make-url)
            (render-json-wait (url->string (make-url myphase-4)) (length rl) )
	    ;;Used for percentage & determining when we want
	    ;;to change the client page
            )
          ;;Extract the icon urls
          (define icos
            (append sfar (extracticourls tl)))
          
          ;;Implicitly capture the state. I love scheme
          (define (myphase-4 request)
	(cond 
		((empty? rl) (phase-3.5 icos request ) )
		(else (phase-3.1 rl (+ 1 n ) icos request))
	)
            )
          ]
    (send/suspend/url/dispatch response-generator))))
(define (phase-3.5 flist request)
  (local [(define (response-generator make-url)
            (render-with-wait "Massaging icon for collage" " - phase almost 4!"
                              (list "/foo2.js") (url->string (make-url myphase-4))
                              
                                             (foldr string-append "Magic Pandas:" (map url->string flist) )) )
          ;;Implicitly capture the state. I love scheme
          (define (myphase-4 request)
            (phase-4 flist request )
            )
          ]
    (send/suspend/url/dispatch response-generator)))
;;Omnomnom I take the favicon list and give you cheese 
(define (phase-4 favicolist request)
  (local [(define (response-generator make-url)
            (render-shirt "Generated collage" (map url->string favicolist)  (url->string (make-url myphase-5)) ))
          (define (myphase-5 request)
            (phase-5 favicolist request)
            )
          ]
    (send/suspend/url/dispatch response-generator)))

(define (phase-5 favicolist request)
  (list #"image/png"  (composite favicolist))
  ;;omnomnom
  )

