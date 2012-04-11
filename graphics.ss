#lang scheme
(provide (all-defined-out))
;(require htdp/image)
;(require mrlib/gif)
(require net/url-structs)
(require net/url)
(require net/head)
(require mzlib/foreign) (unsafe!)
;;(load-extension "mzimagemagick.so")
(require srfi/74)
;;(require ffi/magick (for-syntax scheme/base))
(require "proxy.ss")
(require ffi/magick)
;;(require "magick.ss")
(require "mypath.ss")
;;note:  MagickReadImageBlob reads an image or image sequence from a blob.

(define (composite lurls)
  (MagickGetImageBlob (mycomposite lurls))
  )

(define (mycomposite lurls)
  
  (let ([ww (NewMagickWand)])
    (local
      ((define allwands (filter (lambda (x) (not (void? x))) (map fimg lurls)))
       (define usefulwands (filter (lambda (x) (> (MagickGetImageHeight x) 0 ))
                                   allwands))
       (define wc (length usefulwands))
       (define size 600)
       (define tastey (dt 1 1 size (* 2 wc) ))
       )
      ;(with-handlers (((lambda (x) #t) (lambda (x) ww)))
        (map (lambda (x) (MagickScaleImage x tastey tastey )) usefulwands) ;;Resize images
        (MagickReadImage ww (build-path mypath "bg.png"))
        (MagickScaleImage ww size (+ 0  size))
        (MagickSetFilename ww "composite.png")
        (composeonto ww wc
                     size 0 0 (- size 1) tastey usefulwands usefulwands)
        ;;(map DestroyMagickWand allwands)
        ww
        ;)
     )
   )
  )

(define (dt a b size wc)
  (cond
    ((> wc a) (dt (* 2 a) (+ 1 b) size wc ))
    (else (floor (/ size b))))
  )
(define (mod a b)
  (- a (* b (floor (/ a b))))
  )

(define (hobo a b c size)
  (cond
    ((< (+ a c) size ) (list (+ a c) b))
    (else (list 0 (+ b c )))
  ))

(define (composeonto ww count totalcount xp yp size inc wands wands2)
  (let ((npos (hobo xp yp inc size))
        (morewands (cond
                     ((empty? wands) wands2)
                     ((empty? (rest wands)) (reverse wands2))
                     (else (rest wands)))
        )
        (wands3 (cond
                     ((empty? wands) wands2)
                     ((empty? (rest wands)) (reverse wands2))
                     (else wands2))
        ))
  (cond
    ((empty? wands) ww)
    ((>= yp size) ww)
    (else (MagickCompositeImage ww (first wands) (MagickGetImageCompose ww) xp yp)
          (composeonto ww (+ 1 count) totalcount (car npos) (cadr npos) size inc morewands wands3)
          )
    )
  )
)

(define (toimg port)
 (let ([ww (NewMagickWand)]
       (blob (port->bytes port)))
;;(call-with-exception-handler
   (with-handlers (((lambda (x) #t) (lambda (x) ww)))
   (with-handlers (((lambda (x) #t) (lambda (x)  ;;If something goes wrong ohwell :p
   (MagickSetFilename ww "ico:magicfoo.ico");;MadHax!
   (MagickReadImageBlob ww blob)
   ;;(MagickDisplayImage ww)
   ww)))
     (MagickReadImageBlob ww blob)
     ww)))
     
  )
(define (fimg aurl)
  (with-handlers (((lambda (x) #t) (lambda (x) 
                                     (display (string-append "Failed:"  (url->string aurl)))
                                     (NewMagickWand) )));;If all else fails bail out with an empty image
  (call/input-url aurl get-pure-port toimg))
  )
(define (fetchimg url)
  (call/input-url (netscape/string->url url) get-pure-port toimg)) 
;;(define a (open-input-file "/home/holden/repos/repos/youuseweb/foo.ico"))
;;(let ((ww (NewMagickWand)))
;;    (MagickSetFilename ww "ico:magicfoo.ico")
;;    (MagickReadImageBlob ww (port->bytes a)))
;(define ig (fetchimg "http://www.google.com/favicon.ico"))
;(define ib (fetchimg "http://www.blogger.com/favicon.ico"))
;(define mylurls (list (string->url "http://www.google.com/favicon.ico")  (string->url ;"http://www.blogger.com/favicon.ico") (string->url "http://www.techcrunch.com/favicon.ico")))
;(define mimg (map fimg mylurls))
;(define a (composite mylurls))
(define someurls (list "http://uwaterloo.ca/favicon.ico"
 "http://99designs.com/favicon.ico"
 "http://a9.com/favicon.ico"
 "http://abeautifulsite.net/favicon.ico"
 "http://airbnb.com/favicon.ico"
 "http://www.amazon.com/favicon.ico"
 "http://arstechnica.com/favicon.ico"
 "http://consumerist.com/favicon.ico"
 "http://delicious.com/favicon.ico"
 "http://docs.google.com/favicon.ico"
 "http://failblog.org/favicon.ico"
 "http://gigaom.com/favicon.ico"
 "http://gizmodo.com/favicon.ico"
 "http://holdenkarau.com/favicon.ico"
 "http://icanhascheezburger.com/favicon.ico"
 "http://joelonsoftware.com/favicon.ico"
 "http://kotaku.com/favicon.ico"
 "http://www.krugle.com/favicon.ico"
 "http://lifehacker.com/favicon.ico"
 "http://www.google.com/reader/"
 "http://slashdot.org/favicon.ico"
 "http://twitter.com/favicon.ico"
 "http://www.ubuntu.com/files/favicon-ubuntu.ico"
 "http://vark.com/favicon.ico"
 "http://video.google.com/favicon.ico"
 "http://www.4chan.org/favicon.ico"
 "http://www.imeem.com/favicon.ico"
 "http://www.youtube.com/favicon.ico"
 "http://www.abebooks.com/favicon.ico"
 "http://www.addme.com/favicon.ico"
 "http://aiderss.com/favicon.ico"
 "http://akamai.com/favicon.ico"
 "http://alexa.com/favicon.ico"
 "http://www.android.com/favicon.ico"
 "http://www.ashleymadison.com/favicon.ico"
 "http://www.att.com/favicon.ico"
 "http://www.audible.com/favicon.ico"
 "http://www.blogger.com/favicon.ico"
 "http://boingboing.net/favicon.ico"
 "http://coderow.com/favicon.ico"
 "http://www.crunchgear.com/favicon.ico"
 "http://digg.com/favicon.ico"
 "http://facebook.com/favicon.ico"
 "http://farecast.com/favicon.ico"
 "http://flickr.com/favicon.ico"
 "http://fotolia.com/favicon.ico"
 "http://mail.google.com/mail/"
 "http://www.google.com/favicon.ico"
 "http://istockphoto.com/favicon.ico"
 "http://www.kayak.com/favicon.ico"
 "http://www.kayak.com/favicon.ico"
 "http://cdn.last.fm/flatness/favicon.2.ico"
 "http://linpus.com/favicon.ico"
 "http://www.mywot.com/favicon.ico"
 "http://www.novell.com/favicon.ico"
 "http://www.readwriteweb.com/favicon.ico"
 "http://reddit.com/favicon.ico"
 "http://www.shoemoney.com/favicon.ico"
 "http://skype.com/favicon.ico"
 "http://slackware.com/favicon.ico"
 "http://stumbleupon.com/favicon.ico"
 "http://www.techcrunch.com/favicon.ico"
 "http://www.tuaw.com/favicon.ico"
 "http://www.ubuntu.com/files/favicon-ubuntu.ico"
 "http://www.veoh.com/favicon.ico"
 "http://en.wikipedia.org/favicon.ico"))
;(define c (map string->url someurls))
;(define d (mycomposite c))
;        (MagickReadImage  "/users/hkarau/awesome/bg.jpg")
