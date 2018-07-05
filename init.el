;;; init.el --- Emacs initialization file
;;; Commentary:

;;; Code:
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))


;; EMACS CONFIG ;;

;; Minimalistic setup (No startup, scratch-message, toolbar,menu,scroll bar or tooltip)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

;; Sensible defaults

(setq make-backup-files nil)        ;; No backups
(setq-default word-wrap 1)          ;; Wrap words
(global-visual-line-mode t)
(setq-default fill-column 80)
(pending-delete-mode 1)             ;; Delete selection when typing
(global-auto-revert-mode 1)         ;; Auto refresh
(setq resize-mini-windows nil)
(defalias 'yes-or-no-p #'y-or-n-p) ;; honestly who says "yes" nowadays?

;; PACKAGES ;;

;; Theme

(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula t)
  )

(set-frame-font "Iosevka 12" nil t)

;; Language-specific

;; ORG

(use-package org
  :mode (("\\.org$" . org-mode))
  :bind
  (("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture))
  :config
  (progn (setq org-catch-invisible-edits 'error) ;; No editing of folded regions
    (setq org-startup-indented t) ;; Idented at startup
    (setq org-log-done 'time) ;; Log completion time
    (setq org-hierarchical-todo-statistics nil) ;; Stats are recursive
    (setq org-support-shift-select t)
    (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.6))
   )
  )

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


;; R

(use-package ess
  :ensure t
  :mode ("\\.R\\'" . R-mode)
  :commands R
)

;; C++

;; Clang formatting
(use-package clang-format
  :ensure t
  :bind ("C-c f" . clang-format-region))

;;Magit

(use-package magit
  :ensure t
  :commands magit-get-top-dir
  :bind (("C-c g" . magit-status)
         ("C-c C-g l" . magit-file-log)
         ("C-c f" . magit-grep))
  :init
  (progn
    ;; magit settings
    (setq
     ;; use ido to look for branches
     magit-completing-read-function 'magit-ido-completing-read
     ;; don't put "origin-" in front of new branch names by default
     magit-default-tracking-name-function 'magit-default-tracking-name-branch-only
     ;; open magit status in same window as current buffer
     magit-status-buffer-switch-function 'switch-to-buffer
     ;; highlight word/letter changes in hunk diffs
     magit-diff-refine-hunk t
     )))

;; Editorconfig
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; Visual search-and-replace
(use-package visual-regexp
  :ensure t
  :bind ("C-c r" . vr/replace)
  )

;;(use-package yasnippet
;;  :ensure t
;;  :defer t
;;  :init (yas-global-mode t)
;;  )

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
  :init
  (progn
    (use-package smartparens-config)
    (smartparens-global-mode 1)
    (show-smartparens-global-mode 1))
  :config (setq smartparens-strict-mode t)
 )

;; Para IC

(use-package clips-mode
  :ensure t
  :mode "\\.clp\\'"
  )
