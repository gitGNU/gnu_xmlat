;;  Copyright (C) 2012

;; Original Author: Antonio Cisternino
;; Current Maintainer: NalaGinrut<mulei@gnu.org> who rewritten it with GNU Guile.

;;  XmlAT is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  XmlAT is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define-module (xmlat json)
  #:use-module (xmlat read)
  #:use-module (xmlat strop)
  #:use-module (ice-9 rdelim)
  #:use-module (sxml simple)
  #:export (json->sxml 
	    sxml->json 
	    json->xml 
	    xml->json))

(define-syntax-rule (-> e)
  (call-with-input-string
   e (lambda (p)
       (let ((ts (read p)))
	 (if (symbol? ts)
	     ts
	     (string->symbol ts))))))

(define-syntax =>
  (syntax-rules ()
    ((_ str n)
     (let* ((ss (substring/shared str 0 (string-index str #\:)))
	    (ss (+ ss (object->string n))))
       (-> ss)))
    ((_ str)
     (substring/shared str 0 (string-index str #\:)))))
      
(define read-valid-char
  (lambda (port)
    (skip-the-charset port char-set:whitespace)))

(define skip-invalid-char
  (lambda (port)
    (read-valid-char port)
    (unread-char port)))

(define new-node?
  (lambda (str)
    (and (not (string-contains? str #\,)) 
	 (string-contains? str #\{))))

(define read-inner-node
  (lambda (str port)
    (skip-invalid-char port)
    (read-delimited "," port) ;; skip useless char
    (list (=> str) (json->sxml port))))

(define get-value
  (lambda (port)
    (let ((str (string-trim-both (read-delimited "," port))))
      (skip-invalid-char port)
      (call-with-input-string 
       s (lambda (p) (-> (read p)))))))

(define read-array
  (lambda (port)
    (call-with-input-string 
     str (lambda (p)
	   (let lp((rd (read-line p)) (n 0) (result '()))
	     (cond
	      ((eof-object? rd) 
	       (skip-invalid-char port)
	       (read-delimited "," port) ;; skip useless char
	       result)
	      (else
	       (let* ((ll (string-split str #\:))
		      (k (=> (car ll) n))
		      (v (cadr ll)))
		 (lp (read-line p) (1+ n) `(,@result (,k ,v)))))))))))

(define-syntax-rule (get-key port)
  (read-delimited ":" port))

(define get-end-of-node
  (lambda (json)
    (and (string-null? json) 
	 (error get-end-of-node "invalid json, can't find the end of node"))
    (let lp((n 0) (p 0))
      (cond
       ((< p 0) 
	(error get-end-of-node "invalid json, excessive '}'"))
       ((char=? #\} (string-ref json n))
	(if (zero? p)
	    n
	    (lp (1+ n) (1- p))))
       ((char=? #\{ (string-ref json n))
	(lp (1+ n) (1+ p)))
       (else
	(lp (1+ n) p))))))
  
(define* (json->sxml #:optional (port (current-input-port)))
  (define status 'prelude)
  (let lp((c (read-valid-char port)) (result '()))
    (case status
     ((prelude)
      (set! status 'normal)
      (if (char=? c #\{)
	  (lp (read-valid-char port) result)
	  (error json->sxml "invalid json format!")))
     (else
      (let ((key (=> (get-key port))))
	(cond
	 ((eof-object? c)
	  result)
	 ((new-node? port)
	  (lp (read-char port) `(,@result (,key ,(read-inner-node port))))
	 ((new-array? port)
	  (lp (read-char port) `(,@result (,key ,(read-array port))))
	 (else
	  (lp (read-char port) `(,@result (,key ,(get-values port)))))))))))))

(define* (json->xml #:optional (port (current-input-port)))
  (sxml->xml (json->sxml port)))

(define sxml-array->json
  (lambda (arr)
    
(define sxml-elem->json
  (lambda (elem)
    (call-with-input-string
     (lambda (port)
       (

(define sxml-node?
  (lambda (e)
    (and (list? e) (list? (car e)))))

(define sxml->json 
  (lambda (sxml)
    (cond
     ((null? sxml) "")
     ((sxml-node? sxml)
      (call-with-output-string
       (lambda (port)
	 (for-each 
	  (lambda (x)
	    (display "{\n" port)
	    (format port "~a : ~a;~%" (car x) (sxml->json (cdr x))))
	  sxml)
	 (display sxml port)
	 (display "}\n" port))))
     (else
      (object->string sxml)))))


       ;; (display "{\n" port)
       ;; (cond
       ;; 	((null? sxml) #t);;(display "}" port))
       ;; 	((not (list? sxml)) 
       ;; 	 (display sxml port))
       ;; 	(else
       ;; 	 (format port "~a : ~a;~%" (sxml->json (car sxml))(sxml->json (cdr sxml)))
       ;; 	 (display "}" port)))))))
;;	 (sxml->json (cddr sxml))))))))
  
(define* (xml->json #:optional (port (current-input-port)))
  (sxml->json (xml->sxml port)))


    
		    

	  

