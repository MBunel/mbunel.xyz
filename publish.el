;; Package import
(package-initialize)
(require 'weblorg)
(require 'htmlize)
(setq org-html-htmlize-output-type 'css)

;; Usefull functions definition
(org-add-link-type "rdf_link"
		   :export (lambda (link description backend)
			     (let* ((args (split-string link ",")))
			       (concat "<span " (string-join args " ") ">" description "</span>"))))

(defun beautify-html-files (directory)
  "Iterate over all HTML files in a directory."
  (let ((html-files (directory-files-recursively directory "\\.html\\'")))
    (dolist (file html-files)
      (message "Beautify file: %s" file)
      (shell-command (concat (string-join '("tidy" "-m" "-i" "-w") " ") " " file)))))


;; Org babel execution
(setq org-confirm-babel-evaluate nil) ; Do no ask before running

(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (dot . t)
   (latex . t)
   (emacs-lisp . t)))

; For export tizk pdf in svg
(setq org-babel-latex-pdf-svg-process "pdf2svg %F %O")

;; Website export def

;; Definie main url
(if (string= (getenv "WEBLORG_ENV") "prod")
    (setq weblorg-default-url "https://mbunel.xyz")
  (setq weblorg-default-url "http://localhost:8081"))

(weblorg-site
 :theme nil
 :base-url weblorg-default-url 
 :template-vars '(("site_lang" . "fr-fr")
		  ("site_name" . "MBunel.xyz")
                  ("site_owner" . "Mattia Bunel")
                  ("site_description" . "Mattia Bunel's personal website.")
		  ("site_html_prefix" . "foaf: http://xmlns.com/foaf/0.1/ org: http://www.w3.org/ns/org#")))

;; Main page
(weblorg-route
 :name "index"
 :input-pattern "src/index.org"
 :template "page.html"
 :output "output/index.html"
 :url "/index.html")

;; route for rendering each page
(weblorg-route
 :name "pages"
 :input-pattern "src/pages/*.org"
 :template "page.html"
 :output "output/{{ slug }}.html"
 :url "/{{ slug }}.html")

;; ;; List of blog posts
;; (weblorg-route
;;  :name "blog"
;;  :input-pattern "src/posts/*.org"
;;  :input-aggregate #'weblorg-input-aggregate-all-desc
;;  :template "blog.html"
;;  :output "output/billets.html"
;;  :url "/billets.html")

;; (weblorg-route
;;  :name "categories"
;;  :input-pattern "src/posts/*.org"
;;  :input-aggregate #'weblorg-input-aggregate-by-category

;;  :template "category.html"
;;  :output "output/tags/{{ name }}.html"
;;  :url "/tags/{{ name }}.html")

;; (weblorg-route
;;  :name "posts"
;;  :input-pattern "src/posts/*.org"
;;  :template "post.html"
;;  :output "output/posts/{{ slug }}.html"
;;  :url "/posts/{{ slug }}.html")

;; ;; Cours
;; (weblorg-route
;;  :name "cours"
;;  :input-pattern "src/cours/*.org"
;;  :template "page.html"
;;  :output "output/cours/{{ slug }}.html"
;;  :url "/cours/{{ slug }}.html")

;; (weblorg-route
;;  :name "pages_cours"
;;  :input-pattern "src/cours/*.org"
;;  :input-aggregate #'weblorg-input-aggregate-all-desc
;;  :template "cours.html"
;;  :output "output/cours/cours.html"
;;  :url "/cours/index.html")

;; Static
(weblorg-route
 :name "static"
 :url "/static/{{ file }}")

;; route for static assets that also copies files to output directory
(weblorg-copy-static
 :output "output/static/{{ file }}"
 :url "/static/{{ file }}")

;; ;; RSS
;; (weblorg-route
;;  :name "feed" :output "output/feed.xml"
;;  :url "/feed.xml")


;; Run export
(make-directory "./_temp/static/images" t)
(weblorg-export)
(copy-directory "./src/static/" "./output/" nil t)
(copy-directory "./_temp/" "./output/" nil t t)
(beautify-html-files "./output")
(delete-directory "./_temp" t)
 
