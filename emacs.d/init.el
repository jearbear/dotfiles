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
(setq find-file-visit-truename t)
(setq ring-bell-function 'ignore)

;; set default font
(add-to-list 'default-frame-alist '(font . "-*-Input-normal-normal-ultracondensed-*-20-*-*-*-m-0-iso10646-1"))
(if (eq system-type 'darwin)
    (add-to-list 'default-frame-alist '(font . "-*-Input-normal-normal-ultracondensed-*-15-*-*-*-m-0-iso10646-1")))

;; pipe backup files elsewhere
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq backup-by-copying t)

;; setup package lists
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
(use-package solarized-theme :ensure t :config (load-theme 'solarized-light t))
;; (use-package base16-theme :ensure t :config (load-theme 'base16-gruvbox-dark-soft t))
;; (use-package challenger-deep-theme :ensure t :config (load-theme 'challenger-deep t))
;; (use-package gruvbox :ensure t :config (load-theme 'gruvbox-dark-soft t))
;; (use-package doom-themes :ensure t :config (load-theme 'doom-spacegrey t))
;; (use-package zenburn-theme :ensure t :config (load-theme 'zenburn t))
;; (use-package color-theme-sanityinc-tomorrow :ensure t :config (load-theme 'color-theme-sanityinc-tomorrow-night t))
;; (use-package kaolin-themes :ensure t :config (load-theme 'kaolin-dark t))

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
(use-package go-mode
  :ensure t
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

;; toml-mode
(use-package toml-mode :ensure t)

;; yaml-mode
(use-package yaml-mode :ensure t)

;; scala-mode
(use-package scala-mode :ensure t)

;; haskell-mode
(use-package haskell-mode
  :ensure t)

;; json-mode
(use-package json-mode :ensure t)

;; magit
(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x C-g") 'magit-dispatch-popup)
  (setq vc-handled-backends nil)) ; disable build in VC management

;; git-link
(use-package git-link
  :ensure t
  :config
  (add-to-list 'git-link-remote-alist '("git\\.corp\\.stripe\\.com" git-link-github))
  (add-to-list 'git-link-commit-remote-alist '("git\\.corp\\.stripe\\.com" git-link-commit-github)))

;; ivy, counsel, swiper
(use-package counsel
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	ivy-count-format "%d/%d ")
  (global-set-key (kbd "C-s") 'swiper)
  (global-set-key (kbd "C-x f") 'counsel-git))

;; projectile
(use-package projectile :ensure t)

;; counsel-projectile
(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode 1))

;; flycheck
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode 1))

;; avy
(use-package avy :ensure t)

;; ace-window
(use-package ace-window :ensure t)

;; company-mode
(use-package company
  :ensure t
  :config
  (company-mode 1))

;; evil --- must resist for now
;; (use-package evil :ensure t :config (evil-mode 1))

;; smooth-scrolling
(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1))

;; better scrolling defaults
(setq scroll-margin 10
      scroll-preserve-screen-position 1)

;;; init.el ends here
