
;; Make startup faster by reducing the frequency of garbage
;; collection.  The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold 100000000)                                      ;

;;require use-package
;;{{{ Set up package and use-package

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

;;}}}

;======================Installing missing packages================================

; NO TABS + tab settings ====================================================
(setq-default indent-tabs-mode nil)
(setq standard-indent 2) ; standard indent
(setq tab-width 2) ; or any other preferred value
(setq c-basic-offset tab-width) ; c mode indent
(setq cperl-indent-level tab-width) ; perl mode indent

(add-hook 'text-mode-hook ; text mode indentation
          '(lambda ()
             (setq indent-tabs-mode nil)
             (setq tab-width 2)))

;=================garbage collector tuning=====================================

(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

;; sunrise commander settings =====================
;;(use-package sunrise-commander)

;; find-file-in-project settings ==============================

;; magit settings ============================================
(use-package magit
  :defer t)

;; dash settings ==============================================
(use-package dash
  :defer t)

;; flymake settings ======================================


;; electric pair settings =================================================
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; ivy settings ===========================================
(use-package counsel)
(use-package ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

;; org mode settings ==========================================
(use-package org)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-log-done t)


;; neotree settings =====================================================
(use-package neotree
  :defer t
  :bind
  ("C-x n" . neotree-toggle))

; centaur tabs settings ========================================================
(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-j" . centaur-tabs-backward)
  ("C-;" . centaur-tabs-forward))

;; highlight-indent-guides-settings =============================================
(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-method 'column)
  (setq highlight-indent-guides-auto-odd-face-perc 10)
  (setq highlight-indent-guides-auto-even-face-perc 20)
  (setq highlight-indent-guides-auto-character-face-perc 20)
  )

; ================= real auto save settings =================
(add-hook 'prog-mode-hook 'auto-save-visited-mode)
(add-hook 'text-mode-hook 'auto-save-visited-mode)
(setq auto-save-visited-interval 2) ; seconds

;keep the startup screen from coming up ========================

(setq inhibit-startup-screen t)

; turn on column #'s ======================================
(setq column-number-mode t)

; file reloading mode =======================================
;should reload the file when it change
(auto-revert-mode 1)

 ; set copy/paste/cut buttons to C-c/C-v/etc ==========================
(cua-mode t)

;; turn on rainbow identifiers ===========================
(use-package rainbow-identifiers
  :hook ((prog-mode text-mode) . rainbow-identifiers-mode))

;; turn on rainbow delimiters =========================================
(use-package rainbow-identifiers
  :hook ((prog-mode text-mode) . rainbow-delimiters-mode))

; This has to be after package-initialize autocomplete settings ================
(ac-config-default) ; 
(global-auto-complete-mode t)
(setq ac-auto-show-menu    0.0)
(setq ac-delay             0.0)
(setq ac-menu-height       5)
(setq ac-show-menu-immediately-on-auto-complete t)
(defun auto-complete-mode-maybe ()
  "No maybe for you. Only AC!"
  (unless (minibufferp (current-buffer))
    (auto-complete-mode 1)))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

; custom set variables ===============================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (panda)))
 '(custom-safe-themes
   (quote
    ("68bf77811b94a9d877f9c974c19bafe5b67b53ed82baf96db79518564177c0fb" default)))
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   (quote
    (counsel ivy org-projectile esup magit-svn magit-annex magit-diff-flycheck panda-theme zig-mode centaur-tabs treemacs real-auto-save rainbow-delimiters rainbow-identifiers auto-complete)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Courier New" :foundry "outline" :slant normal :weight bold :height 98 :width normal)))))
