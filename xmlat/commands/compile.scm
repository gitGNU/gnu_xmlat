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

(define-module (xmlat commands compile)
  #:use-module (xmlat utils)
  #:use-module (ice-9 getopt-long)
  #:export (compile))

(define usage 
 "Usage: xmlat compile filename [options]*

  -h | --help         ==> Show this screen.
  -c | --constant     ==> Specify constan name, eg: \"name1=value1 ,name2=value2...\" 
  -t | --template     ==> Specify template filename.
  -o | --stdoutxml    ==> Specify output xml filename.
  -m | --makefile     ==> Specify makefile.
  -s | --htmlspaces   ==> Specify HTML space.
  -p | --prettyformat ==> Use pretty format.

This software is developed by Antonio Cisternino (C)1998, 1999.
And rewritten with GNU Guile by NalaGinrut<mulei@gnu.org> (C)2012.
"）

(define option-spec
  '((help (single-char #\h) (value #f))
    (stdout-xml (single-char #\o) (value #f))
    (constant (single-char #\c) (value #f))
    (template (single-char #\t) (value #f))
    (makefile (single-char #\m) (value #f))
    (html-space (single-char #\s) (value #f))
    (pretty-format (single-char #\p) (value #f))

(define do-xmlat-compile
  (lambda (constant-list template stdout-xml makefile html-spaces pretty)
    #t))
    
(define xmlat-compile
  (lambda args
    (let* ((filename (if (< (length args) 2) (display usage) (car args)))
	   (options (getopt-long args option-spec))
	   (need-help (option-ref options ’help #f))
	   (need-constant (option-ref options 'constant #f))
	   (need-template (option-ref options 'template #f))
	   (need-stdout-xml (option-ref options 'stdoutxml #f))
	   (need-makefile (option-ref options 'makefile #f))
	   (need-html-spaces (option-ref options 'htmlspaces #f))
	   (need-pretty-format (option-ref options 'prettyformat #f)))
      (and need-help (display usage) (primitive-exit)) ;; show help and exit.
      (do-xmlat-compile 
       (and need-constant (parse-constant-list need-constant))
       (and need-template (handle-template need-template))
       (and need-stdout-xml (handle-stdout-xml need-stdout-xml))
       (and need-makefile (handle-makefile need-makefile))
       (and need-html-spaces (handle-html-space need-html-spaces))
       need-pretty-format)))) ;; end xmlat-compile. 
      
(define main xmlat-compile)

