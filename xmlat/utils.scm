;;  Copyright (C) 2013

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

(define-module (xmlat utils)
  #:use-module (xmlat regexp)
  #:use-module (xmlat strop)
  #:use-module (srfi srfi-9)
  #:use-module (ice-9 q)
  #:export (make-args-get-method fetch-module get-file-ext
            get-postfix-handler get-prefix-handler inc! dec!
            new-stack new-queue stack-pop! stack-push! stack-top stack-empty?
            queue-out! queue-in! queue-head queue-tail queue-empty?))

(define new-stack make-q)
(define new-queue make-q)

(define stack-pop! q-pop!)
(define stack-push! q-push!)
(define (stack-top stk) (and (not (q-empty? stk)) (q-front stk)))
(define stack-empty? q-empty?)

(define queue-out! q-pop!)
(define queue-in! enq!)
(define (queue-head q) (and (not (q-empty? q)) (q-front q)))
(define (queue-tail q) (and (not (q-empty? q)) (q-rear q)))
(define queue-empty? q-empty?)

(define-syntax-rule (inc! x) (set! x (1+ x)))
(define-syntax-rule (dec! x) (set! x (1- x)))

(define (get-args-method args n)
  (catch #t 
         (lambda () (list-ref args n))
         (lambda (k . e) 
           #f)))

(define (make-args-get-method args)
  (lambda (n)
    (get-args-method args n)))

(define (fetch-module name)
  (primitive-eval `(resolve-module '(xmlat ,name))))

(define (get-prefix-handler mod prefix name)
  (module-ref mod (symbol-append prefix name)))

(define (get-postfix-handler mod name postfix)
  (module-ref mod (symbol-append name postfix)))

(define-syntax-rule (get-file-ext filename)               
  (let ((i (string-index-right filename #\.)))
    (and i (substring/shared filename (1+ i)))))

(define* (cat file/port #:optional (output-port #f))
  (define get-string-all (@ (rnrs io ports) get-string-all))
  (if (port? file/port)
      (get-string-all file/port)
      (let ((str (if (port? file/port)
                     (get-string-all file/port)
                     (if (file-exists? file/port)
                         (call-with-input-file file/port get-string-all)
                         (error cat "File doesn't exist!" file/port)))))
        (format output-port "~a" str))))
