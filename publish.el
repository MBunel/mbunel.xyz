(package-initialize)
(require 'weblorg)


(require 'htmlize)
(setq org-html-htmlize-output-type 'css)

;; Definie main url
(if (string= (getenv "WEBLORG_ENV") "prod")
    (setq weblorg-default-url "https://mbunel.xyz")
  (setq weblorg-default-url "http://localhost:8081"))

(weblorg-site
 :theme nil
 :base-url weblorg-default-url 
 :template-vars '(("site_name" . "mbunel.xyz")
                  ("site_owner" . "owner@mail.com (owner)")
                  ("site_description" . "owner's personal blog.")))

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

;; List of blog posts
(weblorg-route
 :name "blog"
 :input-pattern "src/posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "blog.html"
 :output "output/billets.html"
 :url "/billets.html")

(weblorg-route
 :name "categories"
 :input-pattern "src/posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-by-category
 
 :template "category.html"
 :output "output/tags/{{ name }}.html"
 :url "/tags/{{ name }}.html")

(weblorg-route
 :name "posts"
 :input-pattern "src/posts/*.org"
 :template "post.html"
 :output "output/posts/{{ slug }}.html"
 :url "/posts/{{ slug }}.html")

;; ;; Blog RSS
(weblorg-route
 :name "feed"
 :input-pattern "src/posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "feed.xml"
 :output "output/feed.xml"
 :url "/feed.xml")

;; Cours
(weblorg-route
 :name "cours"
 :input-pattern "src/cours/*.org"
 :template "page.html"
 :output "output/cours/{{ slug }}.html"
 :url "/cours/{{ slug }}.html")

(weblorg-route
 :name "pages_cours"
 :input-pattern "src/cours/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "cours.html"
 :output "output/cours.html"
 :url "/cours.html")

;; Static
(weblorg-route
 :name "static"
 :url "/static/{{ file }}")

;; route for static assets that also copies files to output directory
(weblorg-copy-static
  :output "output/static/{{ file }}"
  :url "/static/{{ file }}")

(weblorg-export)
(copy-directory "./src/static/" "./output/" nil t)
