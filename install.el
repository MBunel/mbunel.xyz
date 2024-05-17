(package-initialize)
(add-to-list
 'package-archives
 '("melpa" . "http://melpa.org/packages/"))
(package-refresh-contents)
(package-install 'weblorg)
(package-install 'htmlize)
