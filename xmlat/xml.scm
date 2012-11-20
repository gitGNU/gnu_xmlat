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

(define-module (xmlat xml)
  #:use-module (sxml simple)
  #:use-module (sxml xpath)
  #:use-module (ssax sxml)
  #:export (get-sxml-from-file
	    sxml:get-the-node))

(define char-set:xml-whitespace
  (char-set-delete char-set:whitespace #\sp))

(define get-normalized-xml
  (lambda (xml-file)
    (call-with-input-file xml-file
      (lambda (port)
	(string-filter 
	 (lambda (c) (not (char-set-contains? char-set:xml-whitespace c)))
	 (get-string-all port))))))

;; The stratage is, we won't use any XML but SXML in the inner code.
(define get-sxml-from-file
  (lambda (file)
    (call-with-input-string
     (get-normalized-xml file)
     xml->sxml)))

;; use sxml->string rather than sxml->xml
(define write-sxml-to-file-as-xml
  (lambda (sxml filename)
    (call-with-output-file filename
      (lambda (port)
	(display (sxml->string sxml) port)))))

(define string->sxml
  (lambda (str)
    (call-with-input-string 
     str (lambda (port)
	   (xml->sxml port)))))
			   
(define sxml:get-the-node
  (lambda (sxml)
    #t))
    

