#lang scheme
(require "mypath.ss")
(require web-server/servlet-env)
(require web-server/configuration/responders)
(require web-server/managers/lru)
(require "youuseb.ss")
(require web-server/stuffers/base64)
(require web-server/stuffers)
(require web-server/stuffers/hmac-sha1)
(define exp  (lambda (req)
    `(html (head (title "Expired"))
           (body (h1 "Expired")
                 (p "This URL has expired. "
                    "Please return to the home page."
		     "This is likely because of increased load. It shouldn't happen again." )))) )
(define use 2)

(define mymanager (make-threshold-LRU-manager exp	2524000000))

(serve/servlet start
               #:launch-browser? #f
               #:quit? #f
	       #:file-not-found-responder (gen-file-not-found-responder (build-path mypath "static/404.html"))
	       #:log-file  (build-path mypath "mylog5")
	       #:log-format 'extended
               #:listen-ip #f
	       #:manager mymanager
               #:port 8091
	       #:stuffer mystuffer
	       #:command-line? #t
               #:extra-files-paths
               (list (build-path mypath "static"))
               #:servlet-path "/app/"
	       #:stateless? #t)
