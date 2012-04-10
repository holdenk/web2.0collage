#lang scheme
(provide (all-defined-out))
(require htdp/image)
(require mrlib/gif)
(require net/url-structs)
(require net/url)
(require net/head)
(require srfi/13)
(require srfi/14)
;;Takes in a bunch of text and returns a bunch of favicon urls
(define (findicourls turls)
;;  (map first (filter (lambda (x) (not (empty? x))) (map (lambda (x) (filter lexists x)) (map findicourl turls))))
  (map first (filter (lambda (x) (not (empty? x))) (map (lambda (x) (filter url? x))  (map (lambda (x) (map lexists x)) (map findicourl turls)))))
  )

(define (lexists surl)
  (local
    ((define (tninja port)
       (texists surl port)))
  (with-handlers (((lambda (x) #t) (lambda (x) #f))) 
    (call/input-url surl get-impure-port tninja))
  ))
(define (texists surl port)
  (local 
    ((define headers (purify-port port)))
    (cond
      ((and (regexp-match "HTTP/.*301" headers) (extract-field "Location" headers) ) (lexists (string->url (extract-field "Location" headers))))
      ((not (eof-object? port)) surl)
      (else #f)
      
      ;;((and (display headers) 
    ;;     (regexp-match "HTTP/.*200.*OK" headers)  (not (eof-object? port)) )
    
    )
  )
)
(define (findicourl str)
  (list 
   (combine-url/relative (netscape/string->url (string-append "http://" str))  "/favicon.ico")
   (combine-url/relative (netscape/string->url (string-append "http://www." str)) "/favicon.ico")
   )
  )

;(define a(findicourls (list  "techcrunch.com")))
;(define astr "uwaterloo.ca\n99designs.com/\nA9.com\nabeautifulsite.net\nairbnb.com\namazon.com/\narstechnica.com\nconsumerist.com\ndel.icio.us\ndocs.google.com/\nfailblog.org\ngigaom.com\ngizmodo.com\nholdenkarau.com\nicanhascheezburger.com\njoelonsoftware.com\nkotaku.com\nkrugle.com/\nlifehacker.com\nreader.google.com/\nslashdot.org\ntwitter.com/\nubuntu.com/\nvark.com/\nvideo.google.com/\n4chan.org\nImeem.com\nYouTube.com\nabebooks.com\naddme.com\naiderss.com/\nakamai.com\nalexa.com/\nandroid.com\nashleymadison.com\natt.com/\naudible.com\nblogger.com/start\nboingboing.net\ncoderow.com\ncrunchgear.com\ndigg.com\nfacebook.com\nfarecast.com/\nflickr.com/\nfotolia.com/\ngmail.com\ngoogle.com/\nistockphoto.com/\nkayak.com\nkayak.com/\nlast.fm/\nlinpus.com/\nmywot.com/\nnovell.com/linux/\nreadwriteweb.com\nreddit.com\nshoemoney.com\nskype.com\nslackware.com/\nstumbleupon.com/\ntechcrunch.com\ntuaw.com\nubuntu.com/\nveoh.com/\nwikipedia.org\n")
;;(define astrl (string-tokenize astr (char-set-complement (char-set #\newline))))
;(define b (findicourls astrl))