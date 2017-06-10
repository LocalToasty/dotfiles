;;; init --- initializes the emacs editor
;;; Commentary:

;;; Code:
;; add package repositories
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; install missing packages
(setq package-list
      '(adaptive-wrap
        auto-complete
        evil
        evil-magit
        flycheck
        helm
        linum-relative
        rainbow-delimiters))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


;; don't show startup message
(setq inhibit-startup-message t)


;; set theme
(load-theme 'tango-dark)


;; enable evil mode (vi bindings)
(setq evil-toggle-key "C-`")            ; free C-y
(setq evil-shift-width 2)
(require 'evil)
(evil-mode 1)

;; C-c as general purpose escape key sequence.
(defun my-esc (prompt)
  "Functionality for escaping generally. 
   Includes exiting Evil insert state and C-g binding. "
  (cond
   ;; If we're in one of the Evil states that defines [escape] key, return
   ;; [escape] so as Key Lookup will use it.
   ((or (evil-insert-state-p) (evil-replace-state-p) (evil-visual-state-p))
    [escape])
   ;; This is the best way I could infer for now to have C-c work during
   ;; evil-read-key.
   (t (kbd "C-c"))))
(define-key key-translation-map (kbd "C-c") 'my-esc)
;; Works around the fact that Evil uses read-event directly when in operator
;; state, which doesn't use the key-translation-map.
(define-key evil-operator-state-map (kbd "C-c") 'keyboard-quit)

;; Make movement keys work like they should
(define-key evil-normal-state-map
  (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map
  (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map
  (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map
  (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)


;; set tabs to 2 spaces
(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)
(setq tab-width 2)
(setq c-basic-offset 2)


;; wrapping
(require 'adaptive-wrap)
(with-eval-after-load 'adaptive-wrap
  (setq-default adaptive-wrap-extra-indent 2))
(add-hook 'visual-line-mode-hook
          (lambda () (adaptive-wrap-prefix-mode t)))
(global-visual-line-mode t)


;; enable line / column numbers
(require 'linum-relative)
(linum-relative-global-mode)
(setq linum-relative-format "%3s ")
(setq linum-relative-current-symbol "")  ; show current line number
(setq column-number-mode t)


;; auto completion
(require 'auto-complete-config)
(ac-config-default)
;; enable auto completion in latex
(add-hook 'latex-mode-hook (lambda () (auto-complete-mode)))


;; linting
(global-flycheck-mode)


;; window options
(add-to-list 'default-frame-alist '(width . 90))
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(font . "Monospace-10"))


;; parentheses
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)  ; enable colored parens
(show-paren-mode 1)  ; highlight matching parentheses


;; helm mode
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)


;; set default directory for windows
(if (eq system-type 'windows-nt)
    (setq default-directory "~/../../"))


;; save position
(require 'saveplace)
(setq-default save-place t)


(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (haskell-mode haskell-emacs dockerfile-mode markdown-mode rainbow-delimiters linum-relative helm flycheck evil-magit evil auto-complete adaptive-wrap))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
