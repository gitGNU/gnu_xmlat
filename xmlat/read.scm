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

(define-module (xmlat read)
  #:use-module (ice-9 rdelim)
  #:export (read-valid-char
	    skip-the-charset
	    skip-the-char))

(define skip-the-char
  (lambda (port ch)
    (let lp((c (peek-char port)))
      (if (char=? ch c)
	  (lp (read-char port))
	  (read-char port)))))

(define skip-the-charset
  (lambda (port charset)
    (let lp((c (peek-char port)))
      (if (char-set-contains? charset c)
	  (lp (read-char port))
	  (read-char port)))))

(define skip-whitespace
  (lambda (port)
    (skip-the-charset port char-set:whitespace)))

(define read-valid-char
  (lambda (port)
    (skip-whitespace port)
    (read-char port)))
