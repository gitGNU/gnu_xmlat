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

(define-module (xmlat utils)
  #:use-module (xmlat regexp)
  #:use-module (xmlat strop)
  #:use-module (xmlat shell)
  #:export (make-args-get-method =~)

(define (get-args-method args n)
  (catch #t 
    (lambda () (list-ref args n))
    (lambda (k . e) 
      #f)))

(define (make-args-get-method args)
  (lambda (n)
    (get-args-method args n)))

(define-record-type =~:pat
  (=~:make-pat op p1 p2 opt)
  (op pat:op)
  (p1 pat:p1)
  (p2 pat:p2)
  (opt pat:opt))

(define =~:pattern-parser
  (lambda (pat)
    (let ((m 0) 
	  (n 0)
	  (op #f)
	  (p1 #f)
	  (p2 #f)
	  (opt #f))
      (define-syntax-rule (inner-parser i)
	(case m
	  ((0) (set! op (substring n i)) (set! n (1+ i)))
	  ((1) (set! p1 (substring n i)) (set! n (1+ i)))
	  ((2) (set! p2 (substring n i)) (set! n (1+ i)))
	  ((3) (set! opt (substring n i)) (set! n (1+ i)))
	  (else (error =~:opt-parser "invalid m" m))))
    (string-for-each-index (lambda (i)
			     (let ((c (string-ref pat i)))
			       (if (char=? c #\/)
				   (inner-parser i))))
			   pat)
    (=~:make-pat op p1 p2 opt))))

(define =~
  (lambda (str pattern)
    (let ((pat (=~:pattern-parser pattern)))
      (case (pat:op pat)
	(("s") (sed patten str))
	(("tr") (tr str (pat:p1 pat) (pat:p2 pat) (pat:opt pat)))
	(("m" "") (regexp-run str pattern))
	(else (error =~ "wrong operation from pattern!" pattern))))))


	
	  
