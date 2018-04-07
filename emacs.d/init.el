;; redirect custom options to another file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; disable chrome
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; set default font
(custom-set-faces
 '(default ((t (:family "Input" :foundry "FBI " :slant normal :weight normal :height 101 :width extra-condensed)))))

;; setup use-package
(require 'package)

(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

;; ensure use-package is installed and loaded
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; challenger deep theme
(use-package challenger-deep-theme
  :ensure t
  :config (load-theme 'challenger-deep t))

;; elm-mode
(use-package elm-mode
  :ensure t
  :config (setq elm-format-on-save t))

;; rust-mode
(use-package rust-mode
  :ensure t
  :config (setq rust-format-on-save t))

;; toml-mode
(use-package toml-mode :ensure t)

;; load custom file
(load custom-file :noerror)
