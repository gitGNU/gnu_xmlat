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

(define-module (xmlat lint xml)
  #:use-module (xmlat utils)
  #:use-module (ice-9 rdelim)
  #:export (xml-lint))

;; TODO: now there's only pretty-print for XML, without any validation/lint

(define levels 0) ; current level in tags
;;(define in-tag #f) ; whether cur is in a certain tag-pairs
(define %indent-str "")
(define tags (new-stack)) ; a stack to record recursive tags
(define (cur-tag) (stack-top tags)) ; current not-closed-tag

(define-syntax-rule (is-whitespace? c)
  (char-set-contains? char-set:whitespace c))

(define-syntax-rule (indent-for-levels)
  (for-each (lambda (x) (display %indent-str)) (iota (1- levels))))

(define (read-the-tag port)
  (let ((tag (read-delimited " >" port 'peek)))

    (cond
     ((not (char=? #\/ (string-ref tag 0)))
      ;; it's an end-tag, so push the tag
      (stack-push! tags tag)
      ;; if already in a tag, when new tag comes, one more level
      ;;(set! in-tag #t)
      (and (cur-tag) (inc! levels))    
      (indent-for-levels)) ; indent the tag
     ((char=? (peek-char port) #\sp) ; handle attributes
      (display (string-trim-both (read-delimited ">" port 'peek))))
     (else ; it's an end-tag
      (let ((t0 (stack-top tags))
            (t1 (substring/shared tag 1)))
        ;; compare if the end-tag is valid to be closed
        (cond
         ((string=? t0 t1)
          (stack-pop! tags)
          (indent-for-levels) ; indent the tag
          (dec! levels))
          ;;(set! in-tag #f))
         (else (error read-the-tag "Wrong tag pair!" (cons t0 t1)))))))
    (display "<")
    (display tag) ; valid tag, output it
    (let ((c (read-char port)))
      (if (eof-object? c)
          (error read-the-tag "Invalid XML file!" c)
          (display c))))) ; output ">"

(define (do-xml-lint port)
  (let ((c (read-char port)))
    (cond
     ((eof-object? c) #t)
     ((char=? c #\<)
      (read-the-tag port)
      (do-xml-lint port))
     (else 
      (display c)
      (do-xml-lint port)))))

(define* (xml-lint xml #:key (print #f) (indent-str "  "))
  (set! %indent-str indent-str)
  (if print
      (call-with-input-string xml do-xml-lint) 
      (with-output-to-string 
        (lambda ()
          (call-with-input-string xml do-xml-lint)))))
