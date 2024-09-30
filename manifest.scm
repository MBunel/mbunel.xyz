(use-modules
 (guix packages)
 (guix git-download)
 (guix build-system emacs)
 (gnu packages emacs)
 (gnu packages emacs-xyz))


(concatenate-manifests
 (list
  (specifications->manifest '("bash" "make" "pandoc" "emacs-no-x" "emacs-htmlize" "emacs-citeproc-el"))
  (packages->manifest
   (list
    (package
     (name "emacs-weblorg")
     (version "20240711.940")
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/emacs-love/weblorg.git")
             (commit "0db218bd6b2e083546d3a69a022dfb1a08900acd")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0fijrzc96p3jkq53i65bzhmxqyg28a49n21glkzb5b21agy0cdqh"))))
     (build-system emacs-build-system)
     (propagated-inputs (list emacs-templatel))
     (arguments
      '(#:include '("^[^/]+.el$" "^[^/]+.el.in$"
                    "^dir$"
                    "^[^/]+.info$"
                    "^[^/]+.texi$"
                    "^[^/]+.texinfo$"
                    "^doc/dir$"
                    "^doc/[^/]+.info$"
                    "^doc/[^/]+.texi$"
                    "^doc/[^/]+.texinfo$"
                    "^themes$")
		  #:exclude '("^.dir-locals.el$" "^test.el$" "^tests.el$"
			      "^[^/]+-test.el$" "^[^/]+-tests.el$")))
     (home-page "https://emacs.love/weblorg")
     (synopsis "Static Site Generator for org-mode")
     (description #f)
     (license #f))))))
