;;; init.el --- Emacs initialization file
;;; Commentary:

;;; Code:

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)


;; EMACS CONFIG ;;

;; Aesthetics
(setq
 inhibit-startup-screen t
 initial-scratch-message nil
 initial-buffer-choice "~/org/inbox.org"
 resize-mini-windows nil)

(setq-default
 indicate-empty-lines t
 show-trailing-whitespace t
 word-wrap 1
 fill-column 80)

(pending-delete-mode 1)             ;; Delete selection when typing
(global-auto-revert-mode 1)         ;; Auto refresh
(global-visual-line-mode t)
(column-number-mode t)


;; Backups
(setq
 backup-directory-alist '(("." . "~/.emacs.d/backups"))
 delete-old-versions -1
 version-control t
 vc-make-backup-files t
 auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(defalias 'yes-or-no-p #'y-or-n-p) ;; honestly who says "yes" nowadays?

(defun set-frame (_)
  "Set frame properties after it has been created (for emacsclient)."

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

(defun my/clean-frames-and-buffers ()
  "Kill and close unmodified buffers different from the selected frame."
  (interactive)
  (save-window-excursion
    (dolist (buffer (buffer-list))
      (and (buffer-live-p buffer)
           (not (buffer-modified-p buffer))
           (kill-buffer buffer))))
  (save-buffers-kill-terminal)
  )

(global-set-key "\C-x\C-c" 'my/clean-frames-and-buffers)

(setq mode-line-format
      '("%e" mode-line-front-space mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification " " mode-line-position (vc-mode vc-mode) " " mode-line-modes mode-line-misc-info mode-line-end-spaces)
      )

;; PACKAGES ;;

(use-package smex
  :init (smex-initialize)
  :bind ("M-x" . smex)
  )

(use-package ido
  :defer t
  :commands ido-everywhere
  :config
  (progn
    (ido-mode 1)
    (ido-everywhere 1)
    )
  )

(use-package smartparens
  :diminish smartparens-mode
  :init
  (progn
    (smartparens-global-mode 1)
    (show-smartparens-global-mode 1))
  :config (setq smartparens-strict-mode t)
  )

(use-package flycheck
  :ensure flycheck-clang-tidy
  :init  (global-flycheck-mode)
  :config (add-hook 'flycheck-mode-hook #'flycheck-clang-tidy-setup)
  )

(use-package hideshow-org
  :load-path "extra"
  :diminish hs-org/minor-mode
  :config
  (progn
    (add-hook 'python-mode-hook 'hs-org/minor-mode)
    (add-hook 'c++-mode-hook 'hs-org/minor-mode)
    (add-hook 'java-mode-hook 'hs-org/minor-mode)
    )
  )

(use-package eldoc
  :diminish eldoc-mode
  )

;; Theme

(use-package moe-theme
  :config (load-theme 'moe-dark t))

(use-package beacon
  :diminish beacon-mode
  :config (beacon-mode +1))

;; Show pretty symbols
(use-package pretty-mode
  :init (global-pretty-mode t)
  :commands pretty-deactivate-patterns
  :commands pretty-activate-groups
  :commands pretty-deactivate-groups
  :config
  (progn
    (pretty-deactivate-groups '(:logic :nil))
    (pretty-activate-groups '(:greek :arithmetic-nary :punctuation))
    (pretty-deactivate-patterns '(:++ :sum :product :== :===))
    )
  )

(use-package format-all
  :diminish format-all-mode
  :config
  (progn
    (add-hook 'emacs-lisp-mode-hook 'format-all-mode)
    (add-hook 'haskell-mode-hook 'format-all-mode)
    (add-hook 'c++-mode-hook 'format-all-mode)
    (add-hook 'html-mode-hook 'format-all-mode)
    (add-hook 'css-mode-hook 'format-all-mode)
    (add-hook 'javascript-mode-hook 'format-all-mode)
    (add-hook 'java-mode-hook 'format-all-mode)
    )
  )

(use-package py-yapf ;; I don't like `black' from `format-all'
  :config (add-hook 'python-mode-hook 'py-yapf-enable-on-save)
  )

;; Language-specific

;; ORG

(use-package org
  :diminish org-indent-mode
  :ensure org-plus-contrib
  :mode ("\\.org" . org-mode)
  :bind
  (("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture))
  :custom
  (org-catch-invisible-edits 'show "No editing of folded regions")
  (org-startup-indented t "Idented at startup")
  (org-log-done 'time "Log completion time")
  (org-hierarchical-todo-statistics nil "Stats are recursive")
  (org-support-shift-select t)
  (org-directory "~/org")
  (org-agenda-files '("~/org/agenda.org" "~/org/reminders.org") "List of agenda files")
  (org-agenda-span 10 "How many days to show in the agenda")
  (org-agenda-start-on-weekday nil "Start on current day")
  (org-agenda-start-day "-1d" "Show previous day on agenda")
  (org-enforce-todo-dependencies t "TODO dependencies are enforced")
  (org-clock-persist 'history)
  (org-clock-idle-time 10 "Time until being idle")
  (org-ellipsis " …" "Aesthetic change")
  (org-tags-column 0 "Don't flush tags")
  (org-log-into-drawer t "Log done states into drawer")
  (org-todo-keywords
   '((sequence "TODO(t)" "STARTED(s!)" "|" "DONE(d)" "ABANDONED(a@)" "WAITING(w@)"))
   "Tasks can be started or they can be abandoned or waiting")
  (org-todo-keyword-faces
   '(
     ("TODO" . org-todo)
     ("STARTED" . (:foreground "dark goldenrod" :background "yellow" :weight bold))
     ("DONE" . org-done)
     ("ABANDONED" . org-done)
     ("WAITING" . (:foreground "medium blue" :background "deep sky blue" :weight bold))
     )
   "Style for keywords")
  :config
  (org-clock-persistence-insinuate)
  ;; Update clock table on save
  (add-hook 'org-mode-hook
	    (lambda() (add-hook 'before-save-hook
			   'org-update-all-dblocks t t)))

  )

;; ADD CREADO property
;; Adapted from: stackoverflow.com/a/13285957/3414720
(use-package org-expiry
  :custom
  (org-expiry-created-property-name "CREADO")
  (org-expiry-inactive-timestamps t)
  :config
  (add-hook 'org-insert-heading-hook 'org-expiry-insert-created)
  )


;; Archive preserving original tree structure
(use-package org-archive-subtree-hierarchical
  :load-path "extra"
  :after org
  :config
  (setq org-archive-default-command 'org-archive-subtree-hierarchical)
  )

;; Pretty org-bullets
(use-package org-bullets
  :init (add-hook 'org-mode-hook 'org-bullets-mode)
  )

;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  )

;; Haskell

(use-package haskell-mode
  :commands haskell-mode
  :mode "\\.hs\\'"
  :custom
  (haskell-process-suggest-remove-import-lines t)
  (haskell-process-auto-import-loaded-modules t)
  (haskell-process-log t)
  :config (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  )

;; Scala

;; Enable scala-mode and sbt-mode
(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)$")

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
  ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
  (setq sbt:program-options '("-Dsbt.supershell=false"))
  )


(use-package lsp-mode
  :diminish lsp-mode
  :hook ((scala-mode c++-mode python-mode) . lsp)
  :config (setq
	   lsp-prefer-flymake nil
	   lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))
  )

(use-package lsp-ui
  :config (setq lsp-ui-doc-enable t
		lsp-ui-doc-use-childframe t
		lsp-ui-doc-position 'top
		lsp-ui-doc-include-signature t
		lsp-ui-sideline-enable nil
		lsp-ui-flycheck-enable t
		lsp-ui-flycheck-list-position 'right
		lsp-ui-flycheck-live-reporting t
		lsp-ui-peek-enable t
		lsp-ui-peek-list-width 60
		lsp-ui-peek-peek-height 25)
  )
(use-package yasnippet
  :diminish yas-minor-mode
  )
(use-package company-lsp)

;; Misc languages

(use-package yaml-mode)
(use-package rust-mode)
(use-package idris-mode)
(use-package go-mode)
(use-package json-mode)
(use-package pkgbuild-mode)
(use-package nix-mode
  :mode "\\.nix\\'")


;; Editorconfig
(use-package editorconfig
  :diminish editorconfig-mode
  :config (editorconfig-mode 1)
  )

;; Visual search-and-replace
(use-package visual-regexp
  :defer t
  :bind ("C-c r" . vr/replace)
  )

(use-package company
  :defer t
  :diminish company-mode
  :init (global-company-mode)
  :custom
  (company-tooltip-align-annotations t)
  (company-show-numbers t)
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.1)
  (company-dabbrev-downcase nil)
  :config (bind-key [remap completion-at-point] #'company-complete company-mode-map)
  )

;; Python auto completion

(use-package jedi)

(use-package company-jedi
  :after (company jedi)
  :init
  (defvar company-jedi-python-bin "python3")
  :config
  (add-to-list 'company-backends 'company-jedi)
  )

(use-package company-ghci
  :config (add-to-list 'company-backends 'company-ghci)
  )

;; Git

(setq vc-follow-symlinks t)

(use-package diff-hl
  :init (global-diff-hl-mode)
  )


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("26d49386a2036df7ccbe802a06a759031e4455f07bda559dcf221f53e8850e69" "a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" "82358261c32ebedfee2ca0f87299f74008a2e5ba5c502bde7aaa15db20ee3731" default)))
 '(package-selected-packages
   (quote
    (cmake-mode json-mode diff-hl go-mode gnu-elpa-keyring-update yasnippet yaml-mode visual-regexp use-package smex smartparens smart-mode-line rust-mode pretty-mode org-bullets markdown-mode jedi ir-black-theme idris-mode haskell-mode guess-language flycheck editorconfig csv-mode company-jedi cdlatex auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 89)) (:foreground "#D8DEE9" :background nil)))))

(provide 'init)
;;; init.el ends here
