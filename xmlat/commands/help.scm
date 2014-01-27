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

(define-module (xmlat commands help)
  #:use-module (xmlat strop)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:export (show-help))

(define help-str-head
  "
GNU Xml Applicable Tools.
Original Author: Antonio Cisternino
Current Maintainer: NalaGinrut<mulei@gnu.org> who rewritten it with GNU Guile.

commands:

")

(define help-str-foot
  "
God bless hacking.
")

(define *cmd-re* (make-regexp "(.*).scm"))
(define (get-module s)
  (define m (regexp-exec *cmd-re* s))
  (and m (match:substring m 1)))

(define (findout-all-cmds)
  (let* ((file (module-filename (resolve-module '(xmlat utils))))
         (path (format #f "~a/commands/" (dirname file))))
    (filter-map get-module (scandir path))))

(define (cmds->string)
  (call-with-output-string
   (lambda (port)
     (for-each
      (lambda (cmd)
        (let* ((m (resolve-module `(xmlat commands ,(string->symbol cmd))))
               (summary (module-symbol-local-binding m '%summary)))
          (format port "~a ~18t~a~%" cmd summary)))
      (findout-all-cmds)))))

(define (gen-help-str)
  (+ help-str-head  (cmds->string) help-str-foot))

(define (show-help) (display (gen-help-str)))

(define %summary "Show this screen")
(define main show-help)
