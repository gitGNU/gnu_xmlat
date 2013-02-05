;;  Copyright (C) 2013 
;;  Mu Lei known as NalaGinrut<mulei@gnu.org>

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

(package (xmlat (0 0 1))
  (depends (json))
  (synopsis "GNU XML Applicable Tools")
  (description
   "GNU Xmlat is derived from GNU SXML which used to be a tool to define"
   "and implement at same time a markup language. Given a document containing"
   "user defined tags and their definition a new document is produced." 
   "The new document is generated replacing the tags with their definition"
   "(it is possible to associate functions to tags). Xmlat aims to be the new"
   "XML tools for GNU operating system. Besides the old feature of GNU SXML, "
   "it will contains more new features for convenient XML processing, and"
   "provides conversion between XML and other format like json/YAML etc.")
  (homepage "http://www.gnu.org/software/xmlat/")
  (libraries "xmlat")
  (programs "xmlat.scm") ; TODO: we don't need *.scm as a name
  (documentation "README" "COPYING")) ; TODO: add texi manual
