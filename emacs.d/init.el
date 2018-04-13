;;; init.el ---  Init file for Emacs

;;; Commentary:

;; All you should need to get Emacs up and running is this file.  It
;; will install the use-package package if necesarry and then all
;; package dependencies.

;;; Code:

;; redirect custom options to an unused tmp file
(setq custom-file (make-temp-file "custom.el"))

;; disable chrome
(unless (eq system-type 'darwin)
  (menu-bar-mode -1))
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; UI tweaks
(global-hl-line-mode 1)
(setq inhibit-startup-screen t)
(setq vc-follow-symlinks t)

;; set default font
(add-to-list 'default-frame-alist '(font . "-*-Input-normal-normal-ultracondensed-*-20-*-*-*-m-0-iso10646-1"))
(if (eq system-type 'darwin)
    (add-to-list 'default-frame-alist '(font . "-*-Input-normal-normal-ultracondensed-*-15-*-*-*-m-0-iso10646-1")))

;; pipe backup files elsewhere
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq backup-by-copying t)

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

;; themes
;; (use-package solarized-theme :ensure t)
;; (use-package challenger-deep-theme :ensure t)
(use-package doom-themes :ensure t)

(load-theme 'doom-one t)

;; exec-path-from-shell
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; elm-mode
(use-package elm-mode
  :ensure t
  :config (setq elm-format-on-save t))

;; rust-mode
(use-package rust-mode
  :ensure t
  :config (setq rust-format-on-save t))

;; go-mode
(use-package go-mode :ensure t)

;; toml-mode
(use-package toml-mode :ensure t)

;; scala-mode
(use-package scala-mode :ensure t)

;; magit
(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
  (setq vc-handled-backends nil)) ; disable build in VC management

;; git-link
(use-package git-link
  :ensure t
  :config
  (add-to-list 'git-link-remote-alist '("git\\.corp\\.stripe\\.com" git-link-github))
  (add-to-list 'git-link-commit-remote-alist '("git\\.corp\\.stripe\\.com" git-link-commit-github)))

;; projectile
(use-package projectile
  :ensure t
  :config
  (global-set-key (kbd "C-c p p") 'projectile-switch-project)
  (global-set-key (kbd "C-c p f") 'projectile-find-file))

;; ivy, counsel, swiper
(use-package counsel
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	ivy-count-format "%d/%d ")
  (global-set-key (kbd "C-s") 'swiper))

;; flycheck
(use-package flycheck
  :ensure t
  :config (global-flycheck-mode 1))

;; smooth-scrolling
;; (use-package smooth-scrolling :ensure t)

;; better scrolling defaults
(setq scroll-margin 5
      scroll-preserve-screen-position 1)

;;; init.el ends here
