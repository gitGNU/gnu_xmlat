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
  #:use-module (ice-9 getopt-long))

(define usage 
 "Usage: xmlat lint [options]* filename

  -h | --help         ==> Show this screen.
  -t | --type         ==> Specify the file type (ignore it to detect automatically)
  -o | --output       ==> Specify the output file (ignore it to print out it directly)
  -i | --indent       ==> Indent string (two-spaces in default)

Written with GNU Guile by NalaGinrut<mulei@gnu.org> (C)2013.
")

(define option-spec
  '((help (single-char #\h) (value #f))
    (type (single-char #\t) (value #t))
    (output (single-char #\o) (value #t))
    (indent (single-char #\i) (value #t))))

(define* (do-xmlat-lint filename fmt outfile indent)
  (define linter 
    (let ((m (resolve-module `(xmlat lint ,fmt))))
      (if (module-filename m)
          (module-ref m (symbol-append fmt '-lint))
          (error do-xmlat-lint "The format is not supported!" fmt))))
  (define out (if (file-exists? filename)
                  (call-with-input-file filename 
                    (lambda (port) (linter port #:print #t #:indent-str indent)))
                  (error do-xmlat-lint "no such a file" filename)))
  (cond
   (outfile
    ;; NOTE: if outfile exists, it'll be overwrited!!!
    (and (file-exists? outfile) (delete-file outfile))
    (call-with-output-file outfile (lambda (port) (display out port))))
   (else (display out))))

(define (detect-type filename)
  (let ((ext (get-file-ext filename)))
    (if ext
        (string->symbol ext)
        (error detect-type
               "Can't detect the file format! Please specify it!" filename))))

(define (xmlat-lint . args)
  (let* ((filename (get-the-file args))
         (options (getopt-long (get-the-opts args) option-spec))
         (need-help (option-ref options 'help #f))
         (has-type (option-ref options 'type #f))
         (outfile (option-ref options 'output #f))
         (indent (option-ref options 'indent #f)))
    (cond
     (need-help 
      (display usage)
      (primitive-exit)) ;; show help and exit.
     (else
      (do-xmlat-lint filename 
                     (if has-type (string->symbol has-type) (detect-type filename))
                     outfile
                     (if indent indent "  "))))))

(define main xmlat-lint)
