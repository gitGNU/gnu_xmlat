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

(define-module (xmlat shell)
  #:use-module (xmlat strop)
  #:use-module (rnrs io ports)
  #:use-module (ice-9 popen))

(module-export-all! (current-module))

(define shell
  (lambda (str . args)
    ;; FIXME: We could use (os process): run-with-pipe in guile-lib to pass in args
    ;; (let* ((p (run-with-pipe str args))
    ;; 	      (r (cadr p))
    ;; 	      (w (cddr p)))
    ;;       (for-each (lambda (s)
    ;; 	        	  (display s p))
    ;; 		       args)
    (get-string-all (open-input-output-pipe str))))

(define* (sed pattern str #:key (in-place #f) (extend #f) (posix #f)
	      (seperate #f) (unbuffered #f) (file #f))
  (let ((i (if in-place " -i " ""))
	(r (if extend " -r " ""))
	(s (if seperate " -s " ""))
	(u (if unbuffered " -u " "")))
    (if file
	(shell (+ "sed " i r s u pattern str))
	(shell (+ "echo -n " str "|sed " i r s u pattern)))))

(define* (tr str set1 #:optional (set2 "") #:key (opt #f))
  (shell (+ "echo -n " str "|tr " opt set1 set2)))




	      

