;;; init.el ---  Init file for Emacs

;;; Commentary:

;; All you should need to get Emacs up and running is this file.  It
;; will install the use-package package if necesarry and then all
;; package dependencies.

;;; Code:

;;;;;;;;;;;;;;;;;;
;;; Misc settings:
;;;;;;;;;;;;;;;;;;

;; redirect custom options to an unused tmp file
(setq custom-file (make-temp-file "custom.el"))

;; disable chrome
(unless (eq system-type 'darwin)
  (menu-bar-mode -1))
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; show line numbers
(global-display-line-numbers-mode 1)

;; UI tweaks
(global-hl-line-mode 1)
(setq inhibit-startup-screen t
      vc-follow-symlinks t
      find-file-visit-truename t
      ring-bell-function 'ignore)

;; enable auto-pairs
(electric-pair-mode 1)

;; only care about git
(setq vc-handled-backends '(Git))

;; set default font
(add-to-list 'default-frame-alist '(font . "-*-Input-normal-normal-ultracondensed-*-25-*-*-*-m-0-iso10646-1"))
(if (eq system-type 'darwin)
    (add-to-list 'default-frame-alist '(font . "-*-Input-normal-normal-ultracondensed-*-15-*-*-*-m-0-iso10646-1")))

(setq backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; better scrolling defaults
(setq scroll-margin 10
      scroll-preserve-screen-position 1)


;;;;;;;;;;;;;;;;;;
;;; Package setup:
;;;;;;;;;;;;;;;;;;

;; setup package lists
(require 'package)

(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")))

(package-initialize)

;; ensure use-package is installed and loaded
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; install packages declared by default
(setq use-package-always-ensure t)

;; auto-package-update
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t
	auto-package-update-hide-results nil)
  (auto-package-update-maybe))


;;;;;;;;;;;
;;; Themes:
;;;;;;;;;;;

;; themes
;; (use-package solarized-theme :config (load-theme 'solarized-light t))
;; (use-package base16-theme :config (load-theme 'base16-gruvbox-dark-soft t))
;; (use-package challenger-deep-theme :config (load-theme 'challenger-deep t))
;; (use-package gruvbox :config (load-theme 'gruvbox-dark-soft t))
(use-package doom-themes :config (load-theme 'doom-one t))
;; (use-package zenburn-theme :config (load-theme 'zenburn t))
;; (use-package color-theme-sanityinc-tomorrow :config (load-theme 'color-theme-sanityinc-tomorrow-night t))
;; (use-package kaolin-themes :config (load-theme 'kaolin-dark t))
;; (use-package dracula-theme :config (load-theme 'dracula t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Misc/Convenience packages:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; exec-path-from-shell
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; evil
(use-package evil
  :init
  (setq evil-want-integration nil)
  :config
  (evil-mode 1)
  (evil-global-set-key 'normal (kbd "\C-u" ) 'evil-scroll-up)
  (evil-global-set-key 'normal (kbd "SPC f") 'counsel-git)
  (evil-global-set-key 'normal (kbd "SPC l") 'ivy-switch-buffer)
  (evil-global-set-key 'normal (kbd "\\") 'counsel-rg)
  (evil-global-set-key 'normal (kbd "SPC g") 'magit-status))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; evil-magit
(use-package evil-magit)

;; evil-surround
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; evil-commentary
(use-package evil-commentary
  :config
  (evil-commentary-mode)
  (evil-global-set-key 'normal (kbd "SPC /") 'evil-commentary-line)
  (evil-global-set-key 'visual (kbd "SPC /") 'evil-commentary))

;; avy
;; (use-package avy)

;; eyebrowse
(use-package eyebrowse
  :config
  (eyebrowse-mode)
  (eyebrowse-setup-opinionated-keys))

;; company-mode
(use-package company
  :config
  (company-mode 1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Project management packages:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; magit
(use-package magit)

;; git-link
(use-package git-link
  :config
  (add-to-list 'git-link-remote-alist '("git\\.corp\\.stripe\\.com" git-link-github))
  (add-to-list 'git-link-commit-remote-alist '("git\\.corp\\.stripe\\.com" git-link-commit-github)))

;; ivy, counsel, swiper
(use-package counsel
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	ivy-count-format "%d/%d "
	ivy-display-style nil))

;; ivy-rich
;; (use-package ivy-rich
;;   :config
;;   (ivy-set-display-transformer 'ivy-switch-buffer 'ivy-rich-switch-buffer-transformer)
;;   (setq ivy-virtual-abbreviate 'full
;; 	ivy-rich-switch-buffer-align-virtual-buffer t
;; 	ivy-rich-path-style 'abbrev))

;; flycheck
(use-package flycheck
  :config
  (global-flycheck-mode 1))

;; dumb-jump
(use-package dumb-jump
  :config
  (setq dumb-jump-force-searcher 'rg))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Language support packages:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; elm-mode
(use-package elm-mode
  :config (setq elm-format-on-save t))

;; rust-mode
(use-package rust-mode
  :config (setq rust-format-on-save t))

;; go-mode
(use-package go-mode
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

;; company-go
;; company-mode go completion
(use-package company-go
  :config
  (add-hook 'go-mode-hook (lambda ()
                            (set (make-local-variable 'company-backends) '(company-go))
                            (company-mode))))

;; toml-mode
(use-package toml-mode)

;; terraform-mode
(use-package terraform-mode)

;; yaml-mode
(use-package yaml-mode)

;; scala-mode
(use-package scala-mode)

;; haskell-mode
(use-package haskell-mode
  :config
  (setq haskell-stylish-on-save t))

;; hindent
(use-package hindent
  :config
  (add-hook 'haskell-mode-hook #'hindent-mode)
  (setq hindent-reformat-buffer-on-save t))

;; json-mode
(use-package json-mode)

;;; init.el ends here
