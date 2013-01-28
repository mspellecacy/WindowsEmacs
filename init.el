;; Create By: Michael Spellecacy <mspellecacy@frakle.com>
;; Last Edit: 2011-12-29
;; Desc: My personal .emacs, some mine and a lot stolen.

;; Debug!
(setq stack-trace-on-error t)
;; Load up our personal emacs extras
(let ((default-directory  "~/.emacs.d/extras/"))
      (normal-top-level-add-subdirs-to-load-path))

;; Stop spamming my folders with backups, put them somewhere specific.
(if (file-accessible-directory-p (expand-file-name "~/.emacs.d/.trash"))
    (add-to-list 'backup-directory-alist
                 (cons "." (expand-file-name "~/.trash/emacs-backups/"))))

;; Screw it just dont use them...
(setq backup-inhibited t)
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Make things pretty
;(require 'color-theme)
;(eval-after-load "color-theme"
;  '(progn
;     (color-theme-initialize)
;     (color-theme-subtle-hacker)))

;; Because fuck MacOSX thats why.
;; This ONLY exists to return proper home/end key behavior.
;; GRR!
(define-key global-map [M-home] 'beginning-of-buffer)
(define-key global-map [C-home] 'beginning-of-buffer)
(define-key global-map [home] 'beginning-of-line)
(define-key global-map [M-end] 'end-of-buffer)
(define-key global-map [C-end] 'end-of-buffer)
(define-key global-map [end] 'end-of-line)
(define-key global-map [f2] 'start-kbd-macro)
(define-key global-map [f3] 'end-kbd-macro)

;; Line by Line scrolling (so smoooth)
(setq scroll-step 1)

;; Mouse wheel scrolling
(mouse-wheel-mode t)

;; Load nXhtml
(load "~/.emacs.d/extras/nxhtml/autostart.el")
(require 'nxhtml)
(setq mumamo-chunk-coloring 'submode-colored)

;; Load up autocomplete
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/extras/auto-complete/dict")
(require 'auto-complete-config)
(ac-config-default)

;; Syntax Highlight everything we can
(global-font-lock-mode 1)

;; show line wraps
(global-visual-line-mode t)

;; just load lua now..
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(autoload 'scala-mode "scala-mode" "scala editing mode." t)
(autoload 'actionscript-mode "actionscript-mode" "Major mode for actionscript." t)

;; add a bunch of supported modes to autoload on open.
(setq auto-mode-alist (append 
		       '(("\\.html$" . html-mode)
			 ("\\.htm$" . html-mode)
			 ("\\.Cfm$" . html-mode)
			 ("\\.asp$" . html-mode)
			 ("\\.ltt$" . html-mode)
			 ("\\.py$" . python-mode)
			 ("\\.lua$" . lua-mode)
			 ("\\.asm$" . asm-mode)
			 ("\\.sql$" . sql-mode)
			 ("\\.scala$" . scala-mode)
			 ("\\.jsp$" . java-mode)
                         ("\\.mxml$" . nxhtml-mode))
		       auto-mode-alist))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(add-to-list 'auto-mode-alist '("\\.as$" . actionscript-mode))

;; Buffer Quick Switch
; Great for moving around buffers quickly
(require 'pc-bufsw)   
(pc-bufsw::bind-keys [(control tab)] [ (control shift tab) ])

;; sr-speedbar
(require 'sr-speedbar)
(define-key global-map [f6] 'sr-speedbar-toggle)

(require 'lusty-explorer)
(global-set-key (kbd "C-c f") 'lusty-file-explorer)
(global-set-key (kbd "C-c b") 'lusty-buffer-explorer)

;; Yay ido!
(require 'ido)
(ido-mode t)

;; Yay Cedet!
(require 'cedet)

;; Yay Semantic!
(require 'semantic/analyze)
(provide 'semantic-analyze)
(provide 'semantic-ctxt)
(provide 'semanticdb)
(provide 'semanticdb-find)
(provide 'semanticdb-mode)
(provide 'semantic-load)

;; no start-up banner
(setq inhibit-startup-message t)

;; turn delete-selection-mode on at startup
(delete-selection-mode)

;; kill the graphical toolbar 
(tool-bar-mode 0)

;; just-one-line a function I wrote to 
;; compliment just-one-space. 
(defun just-one-line (point mark)
"Removes all \n's from region."
(interactive "*r")
(when (> (point) (mark))
  (exchange-point-and-mark))
(while (< (point) (mark))
  (when (eolp)
	 (when (not (= (point) (mark)))
		(delete-char)
		(just-one-space)))
  (forward-char)))

;;; Define the kill-whole-line Function
;; Wrote this before I knew it was an option :)
;; this is my simple take ...
(defun kill-whole-line ()
  "Kills the entire line."
  (interactive)
  (move-to-left-margin) (kill-line))

;; [Re]Bind CTRL+k to 'my' "kill-whole-line' function
(global-set-key (kbd "C-k") 'kill-whole-line)


;; Bind CTRL+q to, essentially, 'copy'.
(global-set-key (kbd "C-q") 'copy-region-as-kill)

;; Kill current buffer without confirmation unless its modified.
(global-set-key [(control x) (k)] 'kill-this-buffer)

;; yay speedbar
(require 'speedbar)
(speedbar-change-initial-expansion-list "files")

(global-set-key  [f8] 'speedbar-get-focus)

;; Bind F9 to load speedbar
(global-set-key [f9] 'speedbar)

;; ibuffer
(global-set-key [C-x Cb] 'ibuffer)

;; Fuck everything
(global-set-key [f10] 'actionscript-mode)
(global-set-key [f11] 'nxml-mode)


;;Fix tabbing
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 2)

;; Display column numbers only in code.
(column-number-mode t)

;; Display line numbers on the buffer
;; (global-linum-mode t)

;; Setup flyspell 
(flyspell-prog-mode)

;; Highlight matching parenthesis (and other bracket likes)
(show-paren-mode t)

;; Setup hippie-expand (we're going to have to make an eval-after-load          
;; section later)
(defun hippie-expand-case-sensitive (arg)
  "Do case sensitive searching so we deal with gtk_xxx and GTK_YYY."
  (interactive "P")
  (let ((case-fold-search nil))
    (hippie-expand arg)))

(global-set-key "`" 'hippie-expand-case-sensitive)
(global-set-key (kbd "M-SPC") 'hippie-expand-case-sensitive)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

;; M-<delete> kills word forward
;; Since M-DEL (backspace) kills word ,,backwards it only makes sense.
(global-set-key [M-delete] 'kill-word)

;; (require 'tabbar)
;; (tabbar-mode)
;; (defun tabbar-buffer-groups ()
;;   "Return the list of group names the current buffer belongs to.
;; This function is a custom function for tabbar-mode's tabbar-buffer-groups.
;; This function group all buffers into 3 groups:
;; Those Dired, those user buffer, and those emacs buffer.
;; Emacs buffer are those starting with '*'."
;;   (list
;;    (cond
;;     ((string-equal "*" (substring (buffer-name) 0 1))
;;      "Emacs Buffer"
;;      )
;;     ((eq major-mode 'dired-mode)
;;      "Dired"
;;      )
;;     (t
;;      "User Buffer"
;;      )
;;     ))) 

;; (setq tabbar-buffer-groups-function 'tabbar-buffer-groups)

;; (global-set-key [C-M-left] 'tabbar-backward-tab)
;; (global-set-key [C-M-right] 'tabbar-forward-tab)



(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;; recently opened files...
(recentf-mode t)

;; Desktop Save
(require 'desktop)
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")
;; remove desktop after it's been read
(add-hook 'desktop-after-read-hook
	  '(lambda ()
	     ;; desktop-remove clears desktop-dirname
	     (setq desktop-dirname-tmp desktop-dirname)
	     (desktop-remove)
	     (setq desktop-dirname desktop-dirname-tmp)))

(defun saved-session ()
  (file-exists-p (concat desktop-dirname "/" desktop-base-file-name)))

;; use session-restore to restore the desktop manually
(defun session-restore ()
  "Restore a saved emacs session."
  (interactive)
  (if (saved-session)
      (desktop-read)
    (message "No desktop found.")))

;; use session-save to save the desktop manually
(defun session-save ()
  "Save an emacs session."
  (interactive)
  (if (saved-session)
      (if (y-or-n-p "Overwrite existing desktop? ")
	  (desktop-save-in-desktop-dir)
	(message "Session not saved."))
  (desktop-save-in-desktop-dir)))

;; ask user whether to restore desktop at start-up
(add-hook 'after-init-hook
	  '(lambda ()
	     (if (saved-session)
		 (if (y-or-n-p "Restore desktop? ")
		     (session-restore)))))



(desktop-save-mode 1)

;; ECB!
(require 'ecb)
(setq ecb-tip-of-the-day nil)
(global-set-key (kbd "M-D") 'ecb-goto-window-directories)
(global-set-key (kbd "M-S") 'ecb-goto-window-sources)
(global-set-key (kbd "M-F") 'ecb-goto-window-history)
;; (ecb-activate)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (misterioso)))
 '(ecb-layout-name "left3")
 '(ecb-source-path (quote (("c:/workspace/mariner" "mariner"))))
 '(mumamo-background-colors (quote (default)))
 '(mumamo-chunk-coloring 1))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mumamo-background-chunk-major ((t nil)))
 '(mumamo-background-chunk-submode1 ((t (:background "gray9")))))


