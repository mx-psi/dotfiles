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


(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'markdown-mode)
(pending-delete-mode 1)             ;; Delete selection when typing
(global-auto-revert-mode 1)         ;; Auto refresh
(setq resize-mini-windows nil)
(global-visual-line-mode t)

(defun set-frame (_)
  (setq frame-title-format "%f")
  (set-frame-font "Iosevka 12" nil t)
  ;; Minimalistic setup (No startup, scratch-message, toolbar,menu,scroll bar or tooltip)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  ;; Sensible defaults
  (setq make-backup-files nil)        ;; No backups
  (setq-default word-wrap 1)          ;; Wrap words
  (setq-default fill-column 80)
  (defalias 'yes-or-no-p #'y-or-n-p) ;; honestly who says "yes" nowadays?
  (global-set-key "\C-x\C-k" 'kill-buffer) ;; C-x C-k does the same as C-x k
  (global-set-key "\C-x\ f" 'find-file) ;; Same as above, overrides fill-column
)

(add-to-list 'after-make-frame-functions #'set-frame)


;; Path

(setq exec-path (append exec-path '("~/.cabal/bin")))

;; PACKAGES ;;

;; Theme

(use-package spacemacs-common
    :ensure spacemacs-theme
  :config (load-theme 'spacemacs-dark t))


(use-package pretty-mode
  :ensure t
  :init (global-pretty-mode t)
  :config (progn
  (pretty-deactivate-groups
    '(:logic :nil))
  (pretty-activate-groups
    '(:greek :arithmetic-nary :punctuation))
  (pretty-deactivate-patterns '(:circ :++ :sum :product)))
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
  (progn (setq org-catch-invisible-edits 'error) ;; No editing of folded regions
    (setq org-startup-indented t) ;; Idented at startup
    (setq org-log-done 'time) ;; Log completion time
    (setq org-hierarchical-todo-statistics nil) ;; Stats are recursive
    (setq org-support-shift-select t)
    (setq org-directory "~/org")
    (setq org-enforce-todo-dependencies t) ;; TODO dependencies are enforced
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
  :init (progn (setq ess-fancy-comments nil))
)

;; C++

;; Clang formatting
(use-package clang-format
  :ensure t
  :bind ("C-c f" . clang-format-region))

;; Idris

(use-package idris-mode
  :ensure t)

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

;; Spelling

(use-package flyspell
  :ensure t
  :diminish ""
  :init
  (progn
    ;; Enable spell check in plain text / org-mode
    (add-hook 'text-mode-hook 'flyspell-mode)
    (add-hook 'org-mode-hook 'flyspell-mode)
    (setq flyspell-issue-welcome-flag nil)
    (setq flyspell-issue-message-flag nil)

    ;; ignore repeated words
    (setq flyspell-mark-duplications-flag nil)

    (setq-default ispell-program-name "/usr/bin/aspell")
    (setq-default ispell-list-command "list"))
  :config
  (progn
    ;; Make spell check on right click.
    (define-key flyspell-mouse-map [down-mouse-3] 'flyspell-correct-word)
    (define-key flyspell-mouse-map [mouse-3] 'undefined)
    (define-key flyspell-mode-map (kbd "C-;") nil)))

(use-package guess-language         ; Automatically detect language for Flyspell
  :ensure t
  :defer t
  :init (add-hook 'text-mode-hook #'guess-language-mode)
  :config
  (setq guess-language-langcodes '((en . ("en_GB" "English"))
                                   (es . ("es_ES" "Spanish")))
        guess-language-languages '(en es)
        guess-language-min-paragraph-length 45)
  :diminish guess-language-mode)

(add-to-list 'load-path "~/.emacs.d/local")
(require 'pddl-mode)
(require 'google-c-style)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(package-selected-packages
     (quote
       (yasnippet yaml-mode visual-regexp use-package spacemacs-theme smex smartparens smart-mode-line rust-mode pretty-mode powerline pandoc-mode org-bullets mustache-mode monokai-theme mediawiki markdown-mode magit lex jekyll-modes jedi ir-black-theme idris-mode hlint-refactor haskell-mode guess-language flycheck ess emojify editorconfig drag-stuff dracula-theme dockerfile-mode csv-mode csharp-mode company-jedi clips-mode clang-format cdlatex auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
