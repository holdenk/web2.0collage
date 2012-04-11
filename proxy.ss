#lang scheme
(require net/url-structs)
(require net/url)
(require net/head)
(current-proxy-servers (list (list "http" "127.0.0.1" 3128)))