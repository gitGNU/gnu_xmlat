;;  Copyright (C) 2012-2013

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

(define-module (xmlat commands convert)
  #:use-module (xmlat utils)
  #:use-module (ice-9 getopt-long)
  #:use-module (sxml simple)
  #:use-module (xmlat json)
  #:export (main))

(define %summary "Convert between XML/json/sxml etc...")

(define help-str
  "xmlat convert FILENAME --from[-f] from-format --to[-t] to-format")

(define option-spec
  '((from (single-char #\f) (value #t))
    (to (single-char #\t) (value #t))
    (help (single-char #\h) (value #f))))

(define (convert-help)
  (display %summary)(newline)
  (display help-str)(newline))

(define (get-from-handler from)
  (let ((m (fetch-module from))
        (handler (symbol-append from '->scm)))
    (if (module-defined? m handler)
        (module-ref m handler)
        (throw 'xmlat-error "Invalid format of --from" from))))

(define (get-to-handler to)
  (let ((m (fetch-module to))
        (handler (symbol-append 'scm-> to)))
    (if (module-defined? m handler)
        (module-ref m handler)
        (throw 'xmlat-error "Invalid format of --to" to))))

(define (try-convert str from to)
  (let ((f (get-from-handler (string->symbol from)))
        (t (get-to-handler (string->symbol to))))
    (t (f str))))

(define (do-convert filename from to)
  (catch 'xmlat-error
    (lambda ()
      (if (file-exists? filename)
          (try-convert (open-input-file filename) from to)
          (throw 'xmlat-error "No such file" filename))) 
    (lambda (k . e)
      (print-exception (current-error-port) #f k e)
      (exit 1))))

(define (convert . args)
  (while (null? args) (convert-help) (exit 1))
  (let* ((filename (car args))
         (options (getopt-long args option-spec))
	 (need-help? (option-ref options 'help #f))
	 (from-whom (option-ref options 'from #f))
	 (to-whom (option-ref options 'to #f)))
    (cond
     ((or need-help? (not from-whom) (not to-whom))
      (convert-help))
     (else
      (do-convert filename from-whom to-whom)))))

(define main convert)

