#! /usr/local/bin/guile \
-e main
!#

;;  Copyright (C) 2012

;; xmlat
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

(use-modules (ice-9 getopt-long)
	     (xmlat commands)
	     (xmlat commands help))

(define main
  (lambda (args)
      (cond
       ((find-command (if (no-command? args) "help" (cadr args)))
	=> (lambda (mod)
	     (exit (apply (module-ref mod 'main) (if (no-command-args? args)
						     '()
						     (cddr args))))))
       (else
	(format (current-error-port)
		"xmlat: unknown command ~s~%" (cadr args))
	(format (current-error-port)
		"Try `xmlat help' for more information.~%")
	(exit 1)))))
	

