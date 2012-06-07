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

(define-module (xmlat commands)
  #:export (find-command
	    no-command?
	    no-command-args?))

(define no-command?
  (lambda (args)
    (< (length args) 2)))

(define no-command-args?
  (lambda (args)
    (< (length args) 3)))

(define command-path '(xmlat commands))

(define find-command
  (lambda (name)
    (resolve-module `(,@command-path ,(string->symbol name)) #:ensure #f)))




