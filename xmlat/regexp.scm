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

(define-module (xmlat regexp)
  #:use-module (ice-9 regex)
  #:export (=~))

;; simulate '=~' in Perl
;; There're three possible return values:
;; 1. single group or no-group, return the match string;
;; 2. multi-groups, return a procedure who accepts the index of the matches;
;; 3. no match, return #f.
(define-syntax-rule (=~ str re)
  (cond
   ((string-match re str)
    => (lambda (m)
	 (cond
	  ((> (match:count m) 2)
	   (lambda (n)
	     (match:substring m n)))
	  (else
	   (match:substring m 1)))))
   (else
    #f)))


    


