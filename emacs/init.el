;;; init.el --- Emacs initialization file
;;; Commentary:

;;; Code:

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))


;; EMACS CONFIG ;;

;; Aesthetics
(setq
  inhibit-startup-screen t
  initial-scratch-message nil
  initial-major-mode 'markdown-mode
  resize-mini-windows nil)

(setq-default
  indicate-empty-lines t
  show-trailing-whitespace t
  word-wrap 1
  fill-column 80)


(pending-delete-mode 1)             ;; Delete selection when typing
(global-auto-revert-mode 1)         ;; Auto refresh
(global-visual-line-mode t)

;; Backups
(setq
  backup-directory-alist '(("." . "~/.emacs.d/backups"))
  delete-old-versions -1
  version-control t
  vc-make-backup-files t
  auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(defalias 'yes-or-no-p #'y-or-n-p) ;; honestly who says "yes" nowadays?


;; Run only when the frame has been created (for emacsclient)
(defun set-frame (_)
  (setq frame-title-format "%f")
  (set-frame-font "Fira Code 12" nil t)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
)

(add-to-list 'after-make-frame-functions #'set-frame)

(global-set-key "\C-x\C-k" 'kill-buffer) ;; C-x C-k does the same as C-x k
(global-set-key "\C-x\ f" 'find-file) ;; Same as above, overrides fill-column

;; Move between buffers
(global-set-key  (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<C-iso-lefttab>") 'previous-buffer)

;; Path

(setq exec-path (append exec-path '("~/.cabal/bin")))

;; Git

(setq vc-follow-symlinks t)

;; PACKAGES ;;

(use-package diminish :ensure t)
(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind ("M-x" . smex)
  )

(use-package ido
  :ensure t
  :defer t
  :config
  (progn
    (ido-mode 1)
    (ido-everywhere 1)
    )
  )

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :init
  (progn
    (use-package smartparens-config)
    (smartparens-global-mode 1)
    (show-smartparens-global-mode 1))
  :config (setq smartparens-strict-mode t)
  )

;; Theme

(use-package spacemacs-common
    :ensure spacemacs-theme
  :config (load-theme 'spacemacs-dark t))


;; Show pretty symbols
(use-package pretty-mode
  :ensure t
  :init (global-pretty-mode t)
  :config (progn
  (pretty-deactivate-groups
    '(:logic :nil))
  (pretty-activate-groups
    '(:greek :arithmetic-nary :punctuation))
  (pretty-deactivate-patterns '(:circ :++ :sum :product :equality :==)))
  )



;; Language-specific

;; ORG

(use-package org
  :mode (("\\.org$" . org-mode))
  :bind
  (("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture))
  :config
  (progn
    (setq
      org-catch-invisible-edits 'error ;; No editing of folded regions
      org-startup-indented t ;; Idented at startup
      org-log-done 'time ;; Log completion time
      org-hierarchical-todo-statistics nil ;; Stats are recursive
      org-support-shift-select t
      org-directory "~/org"
      org-enforce-todo-dependencies t ;; TODO dependencies are enforced
      org-format-latex-options (plist-put org-format-latex-options :scale 1.6))
   )
  )

;; Pretty org-bullets
(use-package org-bullets
  :ensure t
  :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  )

;; Markdown

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
          ("\\.markdown\\'" . markdown-mode))
  )

;; Haskell

(use-package haskell-mode
  :ensure t
  :commands haskell-mode
  :mode "\\.hs\\'"
  )

;; Rust

(use-package rust-mode
  :ensure t
  :bind (("C-c C-c" . recompile))
  :commands rust-mode
  :mode "\\.rs\\'"
  )

;; C++

;; Clang formatting
(use-package clang-format
  :ensure t
  :bind ("C-c f" . clang-format-region))

;; Misc languages

(use-package idris-mode :ensure t)
(use-package go-mode :ensure t)


;; Editorconfig
(use-package editorconfig
  :diminish editorconfig-mode
  :ensure t
  :config
  (editorconfig-mode 1))

;; Visual search-and-replace
(use-package visual-regexp
  :ensure t
  :bind ("C-c r" . vr/replace)
  )


(use-package company
  :ensure t
  :defer t
  :init (global-company-mode)
  :config
  (progn
    ;; Use Company for completion
    (bind-key [remap completion-at-point] #'company-complete company-mode-map)

    (setq company-tooltip-align-annotations t
          ;; Easy navigation to candidates with M-<n>
          company-show-numbers t)
    (setq company-dabbrev-downcase nil)
    (setq company-minimum-prefix-length 2)
    (setq company-idle-delay 0.1))
  :diminish company-mode)

;; Python auto completion

(use-package jedi
  :ensure t
  )

(use-package company-jedi
  :ensure t
  :init
  (setq company-jedi-python-bin "python3")
  :config
  (add-to-list 'company-backends 'company-jedi))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(custom-safe-themes
     (quote
       ("a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" "82358261c32ebedfee2ca0f87299f74008a2e5ba5c502bde7aaa15db20ee3731" default)))
  '(package-selected-packages
     (quote
       (nordless-theme go-mode gnu-elpa-keyring-update yasnippet yaml-mode visual-regexp use-package spacemacs-theme smex smartparens smart-mode-line rust-mode pretty-mode powerline pandoc-mode org-bullets mustache-mode monokai-theme mediawiki markdown-mode magit lex jekyll-modes jedi ir-black-theme idris-mode hlint-refactor haskell-mode guess-language flycheck ess emojify editorconfig drag-stuff dracula-theme dockerfile-mode csv-mode csharp-mode company-jedi clips-mode clang-format cdlatex auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 89)) (:foreground "#D8DEE9" :background nil)))))
