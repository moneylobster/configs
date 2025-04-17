;;.emacs file
;;CONFIGS
;;Config package archives
(require 'package)
(add-to-list 'package-archives '("gnu"	 . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;use-package startup
(eval-when-compile
  (require 'use-package))

;;PACKAGES
;;ivy and which-key to give keybind hints
(use-package ivy
  :ensure t
  :init
  (defun ivy-toggle-mark ()
    "Toggle mark for current candidate and move forwards."
    (interactive)
    (if (ivy--marked-p)
        (ivy-unmark)
      (ivy-mark)))
  :config
  (setq ivy-use-selectable-prompt t)
  (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  (setq ivy-use-virtual-buffers 'recentf)
  :hook
  (dashboard-after-initialize . ivy-mode)
  :bind (:map ivy-minibuffer-map
              ("C-SPC" . ivy-toggle-mark)))

(use-package counsel
  :ensure t
  :config
  (setq ivy-initial-inputs-alist nil)
  :hook
  (dashboard-after-initialize . counsel-mode))

(use-package avy
  :ensure t)

(use-package ivy-rich
  :ensure t
  :config
  (setq ivy-rich-display-transformers-list '(counsel-find-file
											 (:columns
											  ((ivy-read-file-transformer)
											   (ivy-rich-counsel-find-file-truename
												(:face font-lock-doc-face))))
											 counsel-M-x
											 (:columns
											  ((counsel-M-x-transformer
												(:width 0.4))
											   (ivy-rich-counsel-function-docstring
												(:face font-lock-doc-face))))
											 counsel-describe-function
											 (:columns
											  ((counsel-describe-function-transformer
												(:width 0.4))
											   (ivy-rich-counsel-function-docstring
												(:face font-lock-doc-face))))
											 counsel-describe-variable
											 (:columns
											  ((counsel-describe-variable-transformer
												(:width 0.4))
											   (ivy-rich-counsel-variable-docstring
												(:face font-lock-doc-face))))
											 counsel-recentf
											 (:columns
											  ((ivy-rich-candidate
												(:width 0.8))
											   (ivy-rich-file-last-modified-time
												(:face font-lock-comment-face))))
											 ;; counsel-bookmark
											 ;; (:columns
											 ;;  ((ivy-rich-candidate
											 ;; 	(:width 0.3))
											 ;;   ;; (ivy-rich-bookmark-type)
											 ;;   ;; (ivy-rich-bookmark-info)
											 ;;   ))
											 package-install
											 (:columns
											  ((ivy-rich-candidate
												(:width 30))
											   (ivy-rich-package-version
												(:width 16 :face font-lock-comment-face))
											   (ivy-rich-package-archive-summary
												(:width 7 :face font-lock-builtin-face))
											   (ivy-rich-package-install-summary
												(:face font-lock-doc-face))))))
  :hook
  (dashboard-after-initialize . ivy-rich-mode))

(use-package which-key
  :ensure t
  :custom
  (which-key-sort-order 'which-key-key-order-alpha)
  :hook
  (dashboard-after-initialize . which-key-mode))

;;winum to switch between windows easily
(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))
(use-package winum
  :ensure t
  :bind*
  ("M-1" . winum-select-window-1)
  ("M-2" . winum-select-window-2)
  ("M-3" . winum-select-window-3)
  ("M-4" . winum-select-window-4)
  ("M-5" . winum-select-window-5)
  ("M-6" . winum-select-window-6)
  ("M-7" . winum-select-window-7)
  ("M-8" . winum-select-window-8)
  ("M-9" . winum-select-window-9)
  ("M-0" . switch-to-minibuffer)
  :hook
  (dashboard-after-initialize . winum-mode))

(use-package winner-mode
  :hook
  (dashboard-after-initialize . winner-mode))

;;themes
(use-package doom-themes
  :ensure t
  :defer t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t	 ; if nil, bold is universally disabled
		doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;;(load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package spacemacs-theme
  :ensure t
  :defer t)

(use-package all-the-icons
  :if (display-graphic-p)
  :ensure t)

;;modeline swag
(use-package doom-modeline
  :ensure t
  :custom
  (doom-modeline-minor-modes t)
  (doom-modeline-enable-word-count t)
  :hook
  (dashboard-after-initialize . doom-modeline-mode))

;; hide minor modes
(use-package minions
  :ensure t
  :config (minions-mode t))

;; auto dark mode.
(use-package auto-dark
  :ensure t
  :config (auto-dark-mode t))

(use-package dirvish
  :ensure t
  :init (dirvish-override-dired-mode)
  :config
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons file-size))
  (setq dirvish-preview-dispatchers (remove 'image dirvish-preview-dispatchers))
  (setq dirvish-default-layout nil)
  :bind
  (("C-x d" . dirvish-dwim)
   :map dirvish-mode-map
   ("C-v" . dirvish-yank)
   ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
   ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("f"   . dirvish-file-info-menu)    ; [f]ile info
   ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
   ("s"   . dirvish-quicksort)         ; [s]ort flie list
   ("r"   . dirvish-history-jump)      ; [r]ecent visited
   ("l"   . dirvish-ls-switches-menu)  ; [l]s command flags
   ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
   ("*"   . dirvish-mark-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)))

;;LSP stuff
(use-package eglot
  :ensure t
  :commands eglot
  :hook (eglot-managed-mode . eldoc-box-hover-mode)
  :config
  ;; turn off stupid pystyleguide
  (setq-default eglot-workspace-configuration
				'((pylsp
				   (plugins
					(pycodestyle (enabled . nil))
					(pyflakes (enabled . t))
					(flake8 (enabled . nil))))))
  ;; speedup
  (fset #'jsonrpc--log-event #'ignore)
  :bind
  (:map eglot-mode-map
		("C-c a" . 'eglot-code-actions)
		("C-c r" . 'eglot-rename)))

(use-package tramp
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(use-package eldoc-box
  :ensure t
  :commands (eldoc-box-hover-mode eldoc-box-hover-at-point-mode)
  :custom
  (eldoc-box-clear-with-C-g t)
  (eldoc-box-only-multi-line t))

(use-package dumb-jump
  :ensure t
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :config
  (setq dumb-jump-force-searcher 'rg))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode))

;; corfu for autocomplete
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-quit-no-match t)
  (corfu-on-exact-match 'quit)
  :bind
  (:map corfu-map
	("RET" . nil))
  :init
  (global-corfu-mode))

(use-package cape
  :ensure t
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;; (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  (add-to-list 'completion-at-point-functions #'cape-abbrev))
  ;; (add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  
  ;; ;; Use Company backends as Capfs.
  ;; (add-to-list 'completion-at-point-functions
  ;; 			   (mapcar #'cape-company-to-capf
  ;; 					   (list #'company-files #'company-keywords #'company-dabbrev)))
  

(advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

(use-package yasnippet-capf
  :ensure t
  :after cape
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(use-package helpful
  :ensure t
  :defer t
  :init
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-h x") #'helpful-command)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)
  (global-set-key (kbd "C-h F") #'helpful-function)
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable))
  

(use-package devdocs
  :defer t
  :hook
  (devdocs-mode . visual-line-mode))

(use-package dwim-shell-command
  :ensure t)

(use-package olivetti
  :ensure t
  :hook
  (dashboard-mode . olivetti-mode))

(use-package dired
  :bind (:map dired-mode-map
			  ("C-t" . tab-switch)
			  ("M-<up>". dired-up-directory)))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

;; Python
(use-package python
  :bind (:map python-mode-map
			  ("<f5>" . ag/run-python-script)
			  ("C-c d" . pyinspect-inspect-at-point)
			  ("C-c c" . print-python-expression-in-repl)
			  ("C-c C-d" . ag/python-describe-at-point))
  (:map inferior-python-mode-map
		("M-<up>" . comint-previous-input)
		("M-<down>" . comint-next-input))
  :hook
  (python-mode . eglot-ensure))

(defun ag/run-python-script nil
  "open a fresh python interpreter and execute the python script"
  (interactive)
  (if (get-buffer "*Python*")
	  (kill-buffer "*Python*")
	nil)
  (let
	  ((buf (current-buffer)))
	(run-python nil nil t)
	(switch-to-buffer buf)
	(run-at-time "2 sec" nil #'(lambda ()
								 (python-shell-send-buffer)
								 (switch-to-buffer "*Python*")))))
	
 
(defun print-python-expression-in-repl ()
  "Implying the first statement of the line is actually an expression, prints
its value at the REPL."
  (interactive)
  (let ((initial-point (point)))
	;; mark expression at point
	(beginning-of-line)
	(set-mark (point))
	(python-nav-end-of-statement)

	;; print marked expression in python shell
	(let* ((region-start (min (+ 1 (point)) (point-max)))
		   (expr (string-trim-right
				  (buffer-substring-no-properties region-start (mark)))))
	  (python-shell-send-string
	   (format "print(); print('=> %s'); print(%s, end='')" expr expr)))

	(deactivate-mark)
	(goto-char initial-point)))

(defun ag/python-describe-at-point (symbol process)
  (interactive (list (python-info-current-symbol)
                     (python-shell-get-process)))
  (comint-send-string process (concat "help(" symbol ")\n")))

;; lisp, sly
(defun copy-to-repl-and-eval (&optional begin end)
  "Copies previous sexp to bottom of buffer in repl and evals"
  (interactive (if (use-region-p) (list (region-beginning) (region-end))))
  (backward-sexp)
  (mark-sexp)
  (kill-ring-save (region-beginning) (region-end) t)
  (forward-sexp)
  (let ((slyrepl (sly-mrepl)))
    (if (get-buffer-window slyrepl 'visible)
 (switch-to-buffer-other-window slyrepl)
      (switch-to-buffer slyrepl)))
  (goto-char (point-max))
  (yank)
  (sly-mrepl-return))

(bind-keys :map emacs-lisp-mode-map
		   ("C-<up>" . beginning-of-defun)
		   ("C-<down>" . end-of-defun)
		   ("C-<left>" . left-word)
		   ("C-<right>" . right-word)
		   ("C-M-<up>" . backward-up-list)
		   ("C-M-<down>" . down-list)
		   ("C-M-<left>" . backward-sexp)
		   ("C-M-<right>" . forward-sexp)
		   ("C-M-r" . raise-sexp)
		   ("C-]" . right-char)
		   ("M-[" . insert-parentheses)
		   ("M-]" . move-past-close-and-reindent))

(bind-keys :map lisp-interaction-mode-map
		   ("C-<up>" . beginning-of-defun)
		   ("C-<down>" . end-of-defun)
		   ("C-<left>" . left-word)
		   ("C-<right>" . right-word)
		   ("C-M-<up>" . backward-up-list)
		   ("C-M-<down>" . down-list)
		   ("C-M-<left>" . backward-sexp)
		   ("C-M-<right>" . forward-sexp)
		   ("C-M-r" . raise-sexp)
		   ("C-]" . right-char)
		   ("M-[" . insert-parentheses)
		   ("M-]" . move-past-close-and-reindent))

(defun ag/lisp-swap-parens-hook ()
  "Swap paren and brackets keys."
  (let ((keymap (make-sparse-keymap)))
	(set-keymap-parent keymap key-translation-map)
	(setq-local key-translation-map keymap)
	(define-key key-translation-map (kbd "(") (kbd "["))
	(define-key key-translation-map (kbd ")") (kbd "]"))
	(define-key key-translation-map (kbd "[") (kbd "("))
	(define-key key-translation-map (kbd "]") (kbd ")"))))

(add-hook 'emacs-lisp-mode-hook 'ag/lisp-swap-parens-hook)
(add-hook 'eval-expression-minibuffer-setup-hook #'ag/lisp-swap-parens-hook)
(add-hook 'lisp-interaction-mode-hook 'ag/lisp-swap-parens-hook)

(setq inferior-lisp-program "sbcl --dynamic-space-size 4Gb")
;; lisp electric pair support
(add-hook 'emacs-lisp-mode-hook 'electric-pair-local-mode)
(add-hook 'lisp-mode-hook 'electric-pair-local-mode)

(use-package adjust-parens
  :defer t
  :hook ((lisp-mode emacs-lisp-mode) . adjust-parens-mode))

(use-package markdown-mode
  :ensure t)

;;OTHER CONFIGS
;; slow down the insane scrolling
(setq mouse-wheel-scroll-amount '(3 ((shift) . 5) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
;; and the weird jumping
(setq scroll-conservatively 101)

;; y-n only
(defalias 'yes-or-no-p 'y-or-n-p)
;; don't ask when killing processes
(setq confirm-kill-processes nil)
(setq kill-buffer-query-functions nil)

;;indendation
(setq-default tab-width 4)

;; ctrl-backspace behavior fix
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun aborn/backward-kill-word ()
  "Customize/Smart backward-kill-word."
  (interactive)
  (let* ((cp (point))
		 (backword)
		 (end)
		 (space-pos)
		 (backword-char (if (bobp)
							""			 ;; cursor in begin of buffer
						  (buffer-substring cp (- cp 1)))))
	(if (equal (length backword-char) (string-width backword-char))
		(progn
		  (save-excursion
			(setq backword (buffer-substring (point) (progn (forward-word -1) (point)))))
		  (save-excursion
			(when (and backword			 ;; when backword contains space
					   (s-contains? " " backword))
			  (setq space-pos (ignore-errors (search-backward " ")))))
		  (save-excursion
			(let* ((pos (ignore-errors (search-backward-regexp "\n")))
				   (substr (when pos (buffer-substring pos cp))))
			  (when (or (and substr (s-blank? (s-trim substr)))
						(s-contains? "\n" backword))
				(setq end pos))))
		  (if end
			  (delete-region cp end)
			(if space-pos
				(delete-region cp space-pos)
			  (backward-delete-word 1))))
	  (delete-region cp (- cp 1)))))		 ;; word is non-english word
	

(global-set-key	 [C-backspace]
				 'aborn/backward-kill-word)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;;; org stuff
(add-hook 'org-mode-hook
  (lambda ()
	(local-set-key (kbd "M-_") 'org-down-element)
	(local-set-key (kbd "M-+") 'org-up-element)))

;; Org Modern
(use-package org-modern
  :ensure t
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

;; (add-hook 'org-mode-hook #'org-modern-mode)
;; (add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;; enable Olivetti for org files
(add-hook 'find-file-hook
		  (lambda ()
			(when (string= (file-name-extension buffer-file-name) "org")
			  (olivetti-mode +1))))
  
(use-package org-pomodoro
  :bind (:map org-agenda-mode-map
			  ("M-p" . org-pomodoro)))

(use-package org-alert)

(defun ag/fullscreen nil
  "fullscreen shows clock and battery"
  (interactive)
  (progn
	(toggle-frame-fullscreen)
	(display-battery-mode 'toggle)
	(display-time-mode 'toggle)
	(toggle-menu-bar-mode-from-frame 'toggle)))

(defun ag/pomodoro ()
  "Start a 25 min timer."
  (interactive)
  (org-timer-set-timer 25))

;; rebind keys
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward) ;;also for isearch
(global-set-key (kbd "C-d") 'avy-goto-char-timer)
(define-key isearch-mode-map "\C-d" 'avy-isearch)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-w") 'move-beginning-of-line)
(global-set-key (kbd "C-e") 'move-end-of-line)
(global-set-key (kbd "C-M-w") 'beginning-of-buffer)
(global-set-key (kbd "C-M-e") 'end-of-buffer)
(global-set-key (kbd "C-t") 'tab-switch)
(global-set-key (kbd "C-b") 'ivy-switch-buffer)
(global-set-key (kbd "<f7>") 'org-agenda)
(global-set-key (kbd "<f11>") 'ag/fullscreen)
(global-set-key (kbd "<f12>") 'eshell)
(global-set-key (kbd "C-<f12>") 'ivy-resume)
(global-set-key (kbd "C-<tab>") 'next-window-any-frame)
(global-set-key (kbd "C-S-<tab>") 'previous-window-any-frame)
(global-set-key (kbd "C-x C-r") 'counsel-recentf)
(global-set-key (kbd "C-x f") 'open-in-windows-open)
(global-set-key (kbd "M-<f4>") 'save-buffers-kill-terminal)
(global-set-key (kbd "C-h D") 'devdocs-lookup)
(global-set-key (kbd "C-<f6>") 'jupyter-run-repl)
(global-set-key [remap dabbrev-expand] 'hippie-expand)
(global-set-key (kbd "M-c") 'capitalize-dwim)
(global-set-key (kbd "M-d") 'dwim-shell-command)
(global-set-key (kbd "C-x C-d") 'dired)
;; disable zoom via mouse
(global-set-key (kbd "<pinch>") 'ignore)
(global-set-key (kbd "<C-wheel-up>") 'ignore)
(global-set-key (kbd "<C-wheel-down>") 'ignore)

;; start emacs server
(require 'server)
(add-hook 'dashboard-after-initialize-hook (lambda () (unless (server-running-p)
														(server-start))))
(put 'set-goal-column 'disabled nil)
