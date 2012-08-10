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

(define =~
  (lambda (str pattern)
    (let ((op (string-read-delimited pattern "/")))
      (case op
	(("s") (sed patten str))
	(("") (regexp-run str pattern))
	(else (error =~ "wrong operation from pattern!" pattern))))))


	
	  
