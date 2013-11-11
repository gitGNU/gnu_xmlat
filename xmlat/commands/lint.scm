;;  Copyright (C) 2013

;; Current Maintainer: NalaGinrut<mulei@gnu.org> who write it with GNU Guile.

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

(define-module (xmlat commands lint)
  #:use-module (xmlat utils)
  #:use-module (ice-9 getopt-long)
  #:export (compile))

(define usage 
 "Usage: xmlat lint filename [options]*

  -h | --help         ==> Show this screen.
  -f | --format       ==> Specify the file format (ignore it to detect automatically)
  -o | --output       ==> Specify the output file (ignore it to print out it directly)

Written with GNU Guile by NalaGinrut<mulei@gnu.org> (C)2013.
"）

(define option-spec
  '((help (single-char #\h) (value #f))
    (fmt (single-char #\f) (value #f))
    (output (single-char #\o) (value #f))))

(define (do-xmlat-lint filename fmt outfile)
  (define linter 
    (let ((m (resolve-module `(xmlat lint ,fmt))))
      (unless (module-filename m)
              (module-ref m (symbol-append fmt '-lint))
              (error linter "The format is not supported!" fmt))))
  (define out (if (file-exists? filename)
                  (call-with-input-file filename linter)
                  (error do-xmlat-lint "no such a file" filename)))
  (cond
   (outfile
    ;; NOTE: if outfile exists, it'll be overwrited!!!
    (and (file-exists? outfile) (delete-file outfile))
    (call-with-output-file outfile (lambda (port) (display out port))))
   (else (display out))))

(define (detect-fmt filename)
  (let ((ext (get-file-ext filename)))
    (if ext
        (string->symbol ext)
        (error detect-fmt 
               "Can't detect the file format! Please specify it!" filename))))

(define xmlat-lint
  (lambda args
    (let* ((filename (if (< (length args) 2) (display usage) (car args)))
	   (options (getopt-long args option-spec))
	   (need-help (option-ref options ’help #f))
	   (has-fmt (option-ref options 'fmt #f)))
      (and need-help (display usage) (primitive-exit)) ;; show help and exit.
      (do-xmlat-lint filename 
                     (if has-fmt (string->symbol has-fmt) (detect-fmt filename))
                     outfile))))
      
(define main xmlat-lint)
