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

(define-module (xmlat strop)
  #:use-module (oop goops))

(module-export-all! (current-module))

(define-method (+ (a <string>) (b <string>))
  (string-append a b))

(define-method (* (a <string>) (n <integer>))
  (let lp((result a) (n (1- n)))
    (cond 
     ((zero? n) result)
     (else
      (lp (+ result a) (1- n))))))

;; FIXME: should add regexp support
(define-method (- (a <string>) (b <string>))
  (let ((i (string-contains a b)))
    (if i
	(string-replace a "" i (+ i (string-length b)))
	a)))

(define chop
  (lambda (str)
    (if (string-null? str)
	str
	(string-drop-right str 1))))

(define* (chomp str #:optional (char #\nl))
  (if (string-null? str)
      str
      (if (eq? char (string-ref str (1- (string-length str))))
	  (chop str)
	  str)))

(define (->string obj)
  (object->string obj display))

