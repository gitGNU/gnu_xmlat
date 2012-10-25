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

(define (gen-help-str)
  (+ help-str-head  "" help-str-foot)
  ;; TODO: find out all commands name and summary, then print them all.
  )

(define (show-help) (display (gen-help-str)))

(define %summary "Show this screen")
(define main show-help)
