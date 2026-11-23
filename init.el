;;; init.el --- Emacs configuration
;;; Commentary:
;; Single-file config.  Machine-specific values live in local.el (untracked).
;; Generated Custom settings live in custom.el.
;;; Code:

(setq custom-file
      (expand-file-name "custom.el"
                        (file-name-directory (or load-file-name buffer-file-name))))
(load custom-file t t)


;; font fallback for glyphs
;; (set-fontset-font "fontset-default" nil "Julia Mono")
;; (set-fontset-font "fontset-default" '(#x2bb0 . #x2bff) "Cascadia Mono")

;; (when (member "JuliaMono" (font-family-list))
;;   (add-to-list 'default-frame-alist
;;                '(font . "JuliaMono-8")))

(when (display-graphic-p)
  (set-face-attribute 'default nil :family "scientifica" :height 110 :slant 'italic)
  (set-face-attribute 'fixed-pitch nil :family "scientifica" :height 1.0 :slant 'italic)
  (set-face-attribute 'variable-pitch nil :family "Swis721 BT" :height 0.7 :slant 'normal)
  (set-face-attribute 'fixed-pitch-serif nil :family "CMU Serif" :height 1.0 :slant 'normal)

  (set-fontset-font nil 'latin (font-spec :family "scientifica" :slant 'italic) nil 'prepend)
  (set-fontset-font nil 'latin (font-spec :family "CozetteVector" :slant 'normal) nil 'append)
  ;; Greek: Scientifica only has 50/144 glyphs; JuliaMono covers ά έ ή …
  (set-fontset-font nil 'greek (font-spec :family "Arial") nil 'prepend)
  (set-fontset-font nil 'greek (font-spec :family "JuliaMono" :slant 'italic) nil 'append)
  (set-fontset-font nil 'greek (font-spec :family "scientifica" :slant 'italic) nil 'prepend)
  ;; Cyrillic: Scientifica has none
  (set-fontset-font nil 'cyrillic (font-spec :family "JuliaMono" :slant 'italic) nil 'prepend)
  (set-fontset-font nil 'symbol (font-spec :family "Noto Sans Symbols") nil 'append)
  (set-fontset-font nil 'emoji (font-spec :family "Noto Emoji") nil 'append))

(defun my/mixed-pitch-mode ()
  (mixed-pitch-mode 1)
  (face-remap-add-relative 'default '(:slant normal)))

;; (ag/use-package mixed-pitch
;;   :hook ((org-mode markdown-mode) . my/mixed-pitch-mode))

;; (when (member "scientifica" (font-family-list))
;;   (dolist (script (mapcar #'car script-representative-chars))
;;     (condition-case nil
;;         (set-fontset-font t script (font-spec :family "scientifica") nil 'prepend)
;;       (error nil))))

;; (when (member "Noto Emoji Regular" (font-family-list))
;;   (dolist (script '(symbol emoji))
;;     (set-fontset-font t script (font-spec :family "Noto Emoji Regular") nil 'append)))

;;NATIVE COMP
;;only do it if laptop is charging
(require 'battery)
(defun ag/charging-p ()
  (string= "charging" (cdr (assoc 66 (funcall battery-status-function)))))
(unless (ag/charging-p)
  (setq native-comp-jit-compilation nil))
(setq native-comp-enable-subr-trampolines nil)

;;CONFIGS
;;Config package archives
(require 'package)
(add-to-list 'package-archives '("gnu"  . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;;use-package startup
(require 'use-package)
(require 'use-package-ensure)
(require 'cl-lib)

;; ---------------------------------------------------------------------------
;; Install profile and machine-local overrides
;; ---------------------------------------------------------------------------
;; `ag/profile' is `full' by default.  Set it to `minimal' in local.el to
;; install/configure only `ag/core-packages' plus whatever is already
;; installed.  This is the knob for a small USB installation: optional
;; packages are neither installed nor configured.
(defvar ag/profile 'full)
(defvar ag/full-p nil)

(defvar ag/core-packages
  '(ivy counsel avy ivy-rich which-key winum winner
    doom-themes doom-modeline minions
    corfu cape yasnippet helpful
    magit expand-region markdown-mode)
  "Packages installed even when `ag/profile' is `minimal'.")

;; Portable defaults.  local.el overrides these; a fresh clone still loads.
(defvar ag/dashboard-directory (expand-file-name "~"))
(defvar ag/org-directory (expand-file-name "~/org"))
(defvar ag/roam-directory (expand-file-name "~/roam"))
(defvar ag/wiki-directory (expand-file-name "~/wiki"))
(defvar ag/wiki-home-url nil)
(defvar ag/wiki-up-url nil)
(defvar ag/org-agenda-files nil)
(defvar ag/bibliography nil)
(defvar ag/cite-styles-directory nil)
(defvar ag/moodle-url nil)
(defvar ag/pdf-epdfinfo-program nil)
(defvar ag/wasabi-icon nil)
(defvar ag/ispell-program-name nil)
(defvar ag/ispell-dictionary-alist nil)
(defvar ag/find-program nil)
(defvar ag/slime-lisp-implementations nil)
(defvar ag/local-package-directories nil)
(defvar ag/publishwiki-file nil)
(defvar ag/tramp-default-method nil)
(defvar ag/org-tanglesync-watch-files nil)
(defvar ag/org-latex-classes-safe-values nil)

(defvar ag/local-file
  (expand-file-name "local.el"
                    (file-name-directory (or load-file-name buffer-file-name))))
(when (file-exists-p ag/local-file)
  (load ag/local-file nil t))

(setq ag/full-p (eq ag/profile 'full))

;; Apply values that local.el may have overridden.
(setq org-roam-directory ag/roam-directory)
(when ag/org-agenda-files
  (setq org-agenda-files ag/org-agenda-files))
(when ag/bibliography
  (setq org-cite-global-bibliography (list ag/bibliography)))
(when ag/cite-styles-directory
  (setq org-cite-csl-styles-dir ag/cite-styles-directory))
(when ag/pdf-epdfinfo-program
  (setq pdf-info-epdfinfo-program ag/pdf-epdfinfo-program))
(when ag/ispell-program-name
  (setq ispell-program-name ag/ispell-program-name))
(when ag/ispell-dictionary-alist
  (setq ispell-dictionary "ENU"
        ispell-local-dictionary-alist ag/ispell-dictionary-alist)
  (when (boundp 'ispell-hunspell-dictionary-alist)
    (setq ispell-hunspell-dictionary-alist ispell-local-dictionary-alist)))
(when ag/find-program
  (setq find-program ag/find-program))
(when ag/tramp-default-method
  (setq tramp-default-method ag/tramp-default-method))
(when ag/org-tanglesync-watch-files
  (add-to-list 'safe-local-variable-values
               (cons 'org-tanglesync-watch-files
                     ag/org-tanglesync-watch-files)))
(when ag/org-latex-classes-safe-values
  (add-to-list 'safe-local-variable-values
               (cons 'org-latex-classes ag/org-latex-classes-safe-values)))
(dolist (dir ag/local-package-directories)
  (when (and dir (file-directory-p dir))
    (add-to-list 'load-path dir)))

(defun ag/package-available-p (pkg)
  "Non-nil when PKG can be configured in the current profile."
  (or ag/full-p
      (package-installed-p pkg)
      (locate-library (symbol-name pkg))
      (fboundp pkg)
      (featurep pkg)))

(defun ag/package-wanted-p (pkg)
  "Non-nil when PKG should be installed in the current profile."
  (or ag/full-p (memq pkg ag/core-packages)))

(defun ag/ensure-packages (name args state &optional no-refresh)
  "Install packages for NAME only when the current profile allows it."
  (when (ag/package-wanted-p name)
    (use-package-ensure-elpa name args state no-refresh)))

(setq use-package-ensure-function #'ag/ensure-packages)

(defmacro ag/use-package (name &rest args)
  "Like `use-package', but skip NAME when it is absent in a minimal profile."
  (let ((cell (cl-loop for tail on args
                       when (eq (car tail) :if) return tail)))
    (if cell
        `(use-package ,name
           ,@(cl-substitute `(and (ag/package-available-p ',name)
                                  ,(cadr cell))
                            (cadr cell) args :test #'equal))
      `(use-package ,name :if (ag/package-available-p ',name) ,@args))))

;;PACKAGES

(ag/use-package ivy
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

(ag/use-package counsel
  :ensure t
  :config
  (setq ivy-initial-inputs-alist nil)
  :hook
  (dashboard-after-initialize . counsel-mode))

(ag/use-package avy
  :ensure t)

(ag/use-package ivy-rich
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

(ag/use-package which-key
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
(ag/use-package winum
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

(ag/use-package winner
  :hook
  (dashboard-after-initialize . winner-mode))

(ag/use-package transpose-frame
  :ensure t)

(ag/use-package multiple-cursors
  :ensure t
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-M-<" . mc/insert-numbers)
  ("C-M->" . mc/mark-all-dwim)
  ("S-<down-mouse-1>" . mc/add-cursor-on-click))

;;themes
(ag/use-package doom-themes
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

(ag/use-package spacemacs-theme
  :ensure t
  :defer t)

(ag/use-package all-the-icons
  :if (display-graphic-p)
  :ensure t)

(ag/use-package ef-themes
  :ensure t)

;;modeline swag
(ag/use-package doom-modeline
  :ensure t
  :config
  ;; show battery when viewing pdf
  (doom-modeline-def-modeline 'pdf
	'(bar window-number modals matches buffer-info pdf-pages)
	'(compilation misc-info battery major-mode process vcs time))
  :custom
  (doom-modeline-minor-modes t)
  (doom-modeline-enable-word-count t)
  (doom-modeline-unicode-number nil)
  :hook
  (dashboard-after-initialize . doom-modeline-mode))

;; hide minor modes
(ag/use-package minions
  :ensure t
  :config (minions-mode t))

;; auto dark mode.
(ag/use-package auto-dark
  :ensure t
  :config
  (setq auto-dark-themes '((ef-melissa-dark) (ef-melissa-light)))
  (setq auto-dark-polling-interval-seconds 300)
  (ef-themes-load-theme 'ef-melissa-light)
  (auto-dark-mode t))

(ag/use-package ultra-scroll
  :ensure t
  :config
  (ultra-scroll-mode 1))

;; (ag/use-package dirvish
;;   :ensure t
;;   :init (dirvish-override-dired-mode)
;;   :config
;;   (setq dirvish-attributes           ; The order *MATTERS* for some attributes
;;         '(vc-state subtree-state nerd-icons git-msg file-time file-size)
;;         dirvish-side-attributes
;;         '(vc-state nerd-icons file-size))
;;   (setq dirvish-preview-dispatchers (remove 'image dirvish-preview-dispatchers))
;;   (setq dirvish-default-layout nil)
;;   :bind
;;   (("C-x d" . dirvish-dwim)
;;    :map dirvish-mode-map
;;    ("C-v" . dirvish-yank)
;;    ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
;;    ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
;;    ("f"   . dirvish-file-info-menu)    ; [f]ile info
;;    ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
;;    ("s"   . dirvish-quicksort)         ; [s]ort flie list
;;    ("r"   . dirvish-history-jump)      ; [r]ecent visited
;;    ("l"   . dirvish-ls-switches-menu)  ; [l]s command flags
;;    ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
;;    ("*"   . dirvish-mark-menu)
;;    ("y"   . dirvish-yank-menu)
;;    ("N"   . dirvish-narrow)
;;    ("^"   . dirvish-history-last)
;;    ("TAB" . dirvish-subtree-toggle)
;;    ("M-f" . dirvish-history-go-forward)
;;    ("M-b" . dirvish-history-go-backward)))

;;dashboard on launch
(ag/use-package dashboard
  :ensure t
  :bind
  (:map dashboard-mode-map
	("a" . 'org-agenda)
	("g" . 'ag/dashboard-refresh-buffer)
	;; ("n" . 'ag/sync)
	("f" . 'elfeed)
	("y" . 'yeetube-search)
	("w" . 'server-start))
  :config
  (cd ag/dashboard-directory)
  ;;Custom logo
  (setq dashboard-startup-banner "~/.emacs.d/logo.png")
  ;;Custom agenda view
  (setq dashboard-items '(
						  (recents	. 7)
						  ;; (bookmarks . 7)
						  (dashboard-week . 0)))
						  ;;(agenda . 5)
						  
  (setq dashboard-item-names '(("Agenda for the coming week:" . "To-Do Items:")))
  (setq dashboard-week-agenda t)
  (setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)
  (setq dashboard-center-content t)
  (setq dashboard-agenda-release-buffers t)
  (defun dashboard-insert-week-agenda (&rest _)
	"Insert a copy of org-agenda buffer."
	(insert (save-window-excursion
			  (org-agenda-list nil nil 1)
			  (prog1 (buffer-string)
				(kill-buffer)))))
				
  (add-to-list 'dashboard-item-generators  '(dashboard-week . dashboard-insert-week-agenda))
  
  ;;Custom footer message
  ;; Read file as list of lines
  ;; http://ergoemacs.org/emacs/elisp_read_file_content.html
  (defun read-lines (filePath)
	"Return a list of lines of a file at filePath."
	(with-temp-buffer
	  (insert-file-contents filePath)
	  (split-string (buffer-string) "\n" t)))
  ;; Use file as random footer message
  ;; Created with quotes.org roam file
  (setq dashboard-footer-messages (read-lines "~/.emacs.d/dashboard-quotes.txt"))
  (dashboard-setup-startup-hook))

;;pdf viewer and continuous scrolling
(ag/use-package pdf-tools
  :defer t
  :vc (:url "https://github.com/moneylobster/pdf-tools-personal-fork"
			:lisp-dir "lisp"
			:rev :newest)
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :bind
  (:map pdf-view-mode-map
		("d" . 'pdf-view-auto-slice-minor-mode)
		("t" . 'pdf-view-themed-minor-mode)
		("c" . 'pdf-view-roll-minor-mode)
		("o" . 'pdf-outline))
  :config
  (pdf-loader-install)
  ;; pdf-roll.el defines this map and is only loaded when roll mode is
  ;; first turned on, so the keys cannot go in :bind above.
  (with-eval-after-load 'pdf-roll
    (keymap-set pdf-view-roll-minor-mode-map "SPC" #'pdf-roll-scroll-screen-forward)
    (keymap-set pdf-view-roll-minor-mode-map "DEL" #'pdf-roll-scroll-screen-backward))
  (add-to-list 'load-path "~/.emacs.d/plugins")
  ;; (require 'pdf-continuous-scroll-mode)
  )

(ag/use-package elfeed
  :ensure t
  :defer t)

(ag/use-package elfeed-tube
  :ensure t ;; or :straight t
  :after elfeed
  :demand t
  :config
  ;; (setq elfeed-tube-auto-save-p nil) ; default value
  ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
  (setq elfeed-tube-invidious-url "https://inv.nadeko.net")
  (elfeed-tube-setup)

  :bind (:map elfeed-show-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)
		 ("C-c C-c" . ag/elfeed-mpv-open)
         :map elfeed-search-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)))

(defun ag/mpv-open (&optional url-in)
  "open link (must be an underlined link) with mpv, or open URL-IN in mpv."
  (interactive)
  (let ((url (or url-in (get-text-property (point) 'shr-url))))
	(message "Playing %s..." url)
	(call-process-shell-command (format "mpv %s &" url) nil 0)))

(defun ag/elfeed-mpv-open ()
  "open the current elfeed-tube video with mpv."
  (interactive)
  (let* ((entry elfeed-show-entry)
		 (video-url (elfeed-entry-link entry)))
	(ag/mpv-open video-url)))

(ag/use-package arxiv-mode
  :ensure t
  :bind
  (:map arxiv-mode-map
		("l" . #'recenter-top-bottom)))

;;LSP stuff
(ag/use-package eglot
  :ensure t
  :commands eglot
  :hook (eglot-managed-mode . eldoc-box-hover-mode)
  :config
  (add-to-list 'eglot-server-programs
			   '(python-mode .
							 ;; ("basedpyright-langserver" "--stdio")
							 ("uvx" "ty" "server")
							 ))
  ;; turn off stupid pystyleguide
  (setq-default eglot-workspace-configuration
				'((pylsp
				   (plugins
					(pycodestyle (enabled . nil))
					(pyflakes (enabled . t))
					(flake8 (enabled . nil))))))
  (setq-default
       eglot-workspace-configuration
       '(:basedpyright
		 (:typeCheckingMode "basic")
		 :basedpyright.analysis (:diagnosticSeverityOverrides
								 (:reportUnusedCallResult "none"))))
  ;; speedup
  (fset #'jsonrpc--log-event #'ignore)
  :bind
  (:map eglot-mode-map
		("C-c a" . 'eglot-code-actions)
		("C-c r" . 'eglot-rename)))

(ag/use-package tramp
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  ;; from https://coredumped.dev/2025/06/18/making-tramp-go-brrrr./
  (setq remote-file-name-inhibit-locks t
		tramp-use-scp-direct-remote-copying t
		remote-file-name-inhibit-auto-save-visited t
		tramp-copy-size-limit (* 1024 1024) ;; 1MB
		tramp-verbose 2)
  (cl-pushnew '("-tt")
              (car (alist-get 'tramp-login-args
                              (cdr (assoc "ssh" tramp-methods))))
              :test #'equal))

(ag/use-package eldoc-box
  :ensure t
  :commands (eldoc-box-hover-mode eldoc-box-hover-at-point-mode)
  :custom
  (eldoc-box-clear-with-C-g t)
  (eldoc-box-only-multi-line t))

(ag/use-package dumb-jump
  :ensure t
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :config
  (setq dumb-jump-force-searcher 'rg))

(ag/use-package yasnippet
  :ensure t)

;; corfu for autocomplete
(ag/use-package hotfuzz
  :ensure t
  :custom
  (completion-styles '(hotfuzz basic))
  ;; eglot shoves `flex' into the eglot category via completion-category-defaults;
  ;; if you don't clear it, your override silently loses.
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file       (styles basic partial-completion))  ; fuzzy paths are misery
     (eglot      (styles hotfuzz))
     (eglot-capf (styles hotfuzz)))))

(ag/use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 3)
  (corfu-quit-no-match t)
  (corfu-on-exact-match 'quit)
  (global-corfu-modes '((not org-mode) t))
  :bind
  (:map corfu-map
	("RET" . nil))
  :init
  (global-corfu-mode))

(ag/use-package cape
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

(ag/use-package yasnippet-capf
  :ensure t
  :after cape
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(ag/use-package helpful
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
  

(ag/use-package devdocs
  :ensure t
  :defer t
  :hook
  (devdocs-mode . visual-line-mode))

;;turkish autocorrect
(ag/use-package turkish
  :ensure t)

(ag/use-package popper
  :ensure t ; or :straight t
  :defer t
  :bind (("C-`"	  . popper-toggle)
		 ("M-`"	  . popper-cycle)
		 ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
		'("\\*Messages\\*"
		  "Output\\*$"
		  "\\*Async Shell Command\\*"
		  help-mode
		  ;; compilation-mode
		  ))
  (popper-mode +1)
  (popper-echo-mode +1))

(defun my/csv-field-name ()
  (interactive)
  (let ((field (csv--field-index)))
    (save-excursion
      (goto-char (point-min))
      (csv-forward-field field)
      (message (buffer-substring (save-excursion (csv-backward-field 1) (point)) (point))))))
(ag/use-package csv-mode
  :ensure t
  :defer t
  :bind ((:map csv-mode-map
			   ("C-s" . (lambda ()
						  (interactive)
						  (csv-align-fields nil (point-min) (point-max))
						  (save-buffer)))
			   ("C-c C-f" . my/csv-field-name)
			   ("<insert>" . (lambda ()
							   (interactive)
							   (insert-char ?1)
							   (insert-char ?0)
							   (csv-tab-command)))))
  :hook
  (csv-mode . hl-line-mode)
  (csv-mode . csv-header-line))

(ag/use-package alert
  :commands (alert)
  :config (setq alert-default-style 'toast))
  
(ag/use-package alert-toast
  :after alert
  :config
  (define-advice alert-toast--fill-template (:filter-return (xml) ascii-only)
    "Write non-ASCII characters as XML references, which any code page can carry."
    (replace-regexp-in-string "[^[:ascii:]]"
                              (lambda (c) (format "&#x%X;" (string-to-char c)))
                              xml t t)))

(ag/use-package dwim-shell-command
  :ensure t
  :config
  (setq dwim-shell-command-default-command nil ))

(ag/use-package gnus
  :config
  (unbind-key "C-M-e" gnus-summary-mode-map))

;; Python
(ag/use-package python
  :bind (:map python-mode-map
			  ("<f5>" . ag/run-python-script)
			  ("C-c d" . pyinspect-inspect-at-point)
			  ("C-c c" . print-python-expression-in-repl)
			  ("C-c C-d" . ag/python-describe-at-point))
  (:map inferior-python-mode-map
		("M-<up>" . comint-previous-input)
		("M-<down>" . comint-next-input))
  :config
  (add-to-list 'auto-mode-alist '("\\.ipy\\'" . python-mode))
  (setenv "PYTHONIOENCODING" "utf-8")
  :hook
  (python-mode . eglot-ensure))

(defun ag/python-describe-at-point (symbol process)
  (interactive (list (python-info-current-symbol)
                     (python-shell-get-process)))
  (comint-send-string process (concat "help(" symbol ")\n")))

(defvar old-python-shell-interpreter)
(defvar old-python-shell-interpreter-args)
(ag/use-package pyvenv
  :config
  ;; python venv support
  (add-hook 'python-mode-hook #'pyvenv-mode)
  (setq pyvenv-post-deactivate-hooks
		(list (lambda ()
				(setq python-shell-interpreter old-python-shell-interpreter)
				(setq python-shell-interpreter-args old-python-shell-interpreter-args)))))
(defun uv-activate ()
  "Activate Python environment managed by uv based on current project directory.
Looks for .venv directory in project root and activates the Python interpreter."
  (interactive)
  (let* ((project-root (project-root (project-current t)))
         (venv-path (expand-file-name ".venv" project-root))
         (python-path (expand-file-name
                       (if (eq system-type 'windows-nt)
                           "Scripts/python.exe"
                         "bin/python")
                       venv-path)))
    (if (file-exists-p python-path)
        (progn
          ;; Set Python interpreter path
		  (setq old-python-shell-interpreter python-shell-interpreter)
          (setq python-shell-interpreter python-path)
		  ;; Empty args, save for later.
		  (setq old-python-shell-interpreter-args python-shell-interpreter-args)
		  (setq python-shell-interpreter-args "-i")

          ;; Update exec-path to include the venv's bin directory
          (let ((venv-bin-dir (file-name-directory python-path)))
            (setq exec-path (cons venv-bin-dir
                                  (remove venv-bin-dir exec-path))))

          ;; Update PATH environment variable
          (setenv "PATH" (concat (file-name-directory python-path)
                                 path-separator
                                 (getenv "PATH")))

          ;; Update VIRTUAL_ENV environment variable
          (setenv "VIRTUAL_ENV" venv-path)

          ;; Remove PYTHONHOME if it exists
          (setenv "PYTHONHOME" nil)

          (message "Activated UV Python environment at %s" venv-path))
      (error "No UV Python environment found in %s" project-root))))

(ag/use-package pyinspect
  :defer t)

(ag/use-package ein
  :defer t
  :config
  (setq ein:output-area-inlined-images t))

(ag/use-package jupyter
  :ensure t
  :defer t
  :config
  (setq jupyter-api-authentication-method 'password)
  :hook (python-mode . (lambda () (bind-key "<f6>" #'jupyter-repl-associate-buffer #'python-mode-map)))
  :hook (julia-mode . (lambda () (bind-key "<f6>" #'jupyter-repl-associate-buffer #'julia-mode-map)))
  :hook (jupyter-repl-interaction-mode . (lambda ()
							   (progn
								 (bind-key "C-<up>" #'jupyter-repl-history-previous
										   jupyter-repl-mode-map)
								 (bind-key "M-<up>" #'jupyter-repl-history-previous
										   jupyter-repl-mode-map)
								 (bind-key "C-<down>" #'jupyter-repl-history-next
										   jupyter-repl-mode-map)
								 (bind-key	"M-<down>" #'jupyter-repl-history-next
											jupyter-repl-mode-map)))))

(defun ag/jupyter-eval-defun ()
  "python-mode's C-M-x adapted for jupyter"
  (interactive)
  (let ((starting-pos (point)))
	(save-excursion
	  (jupyter-eval-region nil
						   (progn
							 (end-of-line 1)
							 (while (and (or (python-nav-beginning-of-defun)
											 (beginning-of-line 1))
										 (> (current-indentation) 0)))
							 (while (and
									 (eq (forward-line -1) 0)
									 (if (looking-at (python-rx decorator))
										 t
									   (forward-line 1)
									   nil)))
							 (point-marker))
						   (progn
							 (goto-char starting-pos)
							 (or (python-nav-end-of-defun)
								 (end-of-line 1))
							 (point-marker))))))
(advice-add 'jupyter-eval-defun :override 'ag/jupyter-eval-defun)


;; spelling
(ag/use-package ispell
  :defer t)

;; (add-hook 'org-mode-hook #'flyspell-mode)


(ag/use-package olivetti
  :ensure t
  :hook
  (dashboard-mode . olivetti-mode)
  (org-mode . olivetti-mode))

(ag/use-package erc
  :config
  (setq erc-sasl-user "uhuh")
  (setq erc-autojoin-channels-alist
		'(("Libera.Chat" "#emacs" "#lispcafe" "#commonlisp"))))

(ag/use-package dired
  :bind (:map dired-mode-map
			  ("C-t" . tab-switch)
			  ("M-<up>". dired-up-directory)))

(ag/use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(ag/use-package project
  :ensure nil ; built-in
  :custom (project-vc-extra-root-markers
           '("adainclude" "alire.toml" ".project" ".projectile")))

;; ada
(defun alr-run ()
  "Build and run project"
  (interactive)
  (compile "alr run" t))

(defun alr-build ()
  "Build project"
  (interactive)
  (compile "alr build"))

(defun alr-clean ()
  "Clean build files"
  (interactive)
  (compile "alr clean"))

(defun alr-prove ()
  "Run gnatprove"
  (interactive)
  (compile "alr gnatprove"))

(ag/use-package ada-ts-mode
  :ensure t
  :hook
  (ada-ts-mode . eglot-ensure)
  (ada-ts-mode . (lambda () (setq indent-tabs-mode nil)))
  (ada-ts-mode . (lambda () (add-hook 'before-save-hook (lambda ()
														  (progn (eglot-format) (ada-ts-mode-case-format-buffer)))
									  nil t)))
  :bind (:map ada-ts-mode-map
			  ("C-c C-c" . #'alr-run)
			  ("C-c C-k" . #'alr-build)
			  ("C-c C-u" . #'alr-clean)
			  ("C-c C-s" . #'alr-prove)
			  ("C-c C-d" . #'ff-find-other-file)))

;; lisp, slime
(defun copy-to-repl-and-eval (&optional begin end)
  "Copies previous sexp to bottom of buffer in repl and evals"
  (interactive (if (use-region-p) (list (region-beginning) (region-end))))
  (slime-check-connected)
  (backward-sexp)
  (mark-sexp)
  (kill-ring-save (region-beginning) (region-end) t)
  (forward-sexp)
  (let ((repl (slime-output-buffer)))
    (if (get-buffer-window slyrepl 'visible)
		(switch-to-buffer-other-window repl)
      (switch-to-buffer repl)))
  (goto-char (point-max))
  (yank)
  (slime-repl-return))

(defun ag/lisp-swap-parens-hook ()
  "Swap paren and brackets keys."
  (let ((keymap (make-sparse-keymap)))
	(set-keymap-parent keymap key-translation-map)
	(setq-local key-translation-map keymap)
	(define-key key-translation-map (kbd "(") (kbd "["))
	(define-key key-translation-map (kbd ")") (kbd "]"))
	(define-key key-translation-map (kbd "[") (kbd "("))
	(define-key key-translation-map (kbd "]") (kbd ")"))))

(defun apply-lisp-bindings (mode-map mode-hook)
  "Apply the bindings and settings I use for lisp for the given mode-map and mode-hook. Skip if nil."
  (progn
	(when mode-map
	  (bind-keys :map mode-map
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
			   ("M-]" . move-past-close-and-reindent)))
	(when mode-hook
	  (add-hook mode-hook 'ag/lisp-swap-parens-hook)
	  (add-hook mode-hook 'electric-pair-local-mode))))

(dolist (i '((lisp-mode-map lisp-mode-hook)
			 (emacs-lisp-mode-map emacs-lisp-mode-hook)
			 (lisp-interaction-mode-map lisp-interaction-mode-hook)
			 (nil eval-expression-minibuffer-setup-hook)
			 (lisp-data-mode-map lisp-data-mode-hook)))
  (apply-lisp-bindings (car i) (cadr i)))

(ag/use-package testiere-mode
  :vc (:url "https://github.com/dotemacs/testiere-mode.el"
	   :branch "main"))

;; (ag/use-package sly
;;   :ensure t
;;   :defer t
;;   :vc (:url "https://github.com/moneylobster/slyfork"
;; 			:rev :newest)
;;   :config
;;   (setq sly-lisp-implementations
;; 		'((sbcl ("sbcl" "--dynamic-space-size" "4096")))
;;   ;; (add-to-list 'sly-contribs 'sly-clime 'append)
;;   (apply-lisp-bindings 'sly-mode-map 'sly-mode-hook)

;;   (defun ccl ()
;; 	(interactive)
;; 	(sly 'ccl))
  
;;   :bind (:map sly-mode-map
;; 			  ;; ("C-M-<up>" . sly-button-forward)
;; 			  ;; ("C-M-<down>" . sly-button-backward)
;; 			  ("M-<up>" . sly-mrepl-previous-input-or-button)
;; 			  ("M-<down>" . sly-mrepl-next-input-or-button)
;; 			  ("C-c t" . testiere-toggle)
;; 			  ("C-c C-j" . copy-to-repl-and-eval)
;; 			  ("C-c C-e" . sly-overlay-eval-defun)
;; 			  ("C-c RET" . sly-macroexpand-1)
;; 			  ("C-c C-m" . sly-macroexpand-1-inplace)))

(ag/use-package slime
  :ensure t
  :defer t
  :config
  (setq slime-lisp-implementations
        (or ag/slime-lisp-implementations
            (if (eq system-type 'windows-nt)
                '((sbcl ("sbcl" "--dynamic-space-size" "4096"))
                  (ccl ("wx86cl64")))
              '((sbcl ("sbcl" "--dynamic-space-size" "4096"))))))

  (slime-setup '(slime-fancy slime-asdf slime-quicklisp slime-sbcl-exts))

  (setq slime-fuzzy-default-completion-ui t)
  (setq slime-completion-at-point-functions '(slime-fuzzy-complete-symbol
											  slime-filename-completion))

  (apply-lisp-bindings 'slime-mode-map 'slime-mode-hook)

  (with-eval-after-load 'slime-repl
    (apply-lisp-bindings 'slime-repl-mode-map 'slime-repl-mode-hook)
    (bind-keys :map slime-repl-mode-map
               ("M-<up>"   . slime-repl-previous-input)
               ("M-<down>" . slime-repl-next-input)))
  
  (add-hook 'slime-repl-mode-hook
          (lambda ()
            (setq-local minor-mode-overriding-map-alist
                        (cons (cons 'electric-pair-mode electric-pair-mode-map)
                              minor-mode-overriding-map-alist))))

  (defun ccl () (interactive) (slime 'ccl))
  
  :bind (:map slime-mode-map
			  ;; ("C-M-<up>" . sly-button-forward)
			  ;; ("C-M-<down>" . sly-button-backward)
			  ("M-<up>" . slime-repl-previous-input)
			  ("M-<down>" . slime-repl-next-input)
			  ("C-c t" . testiere-toggle)
			  ("C-c C-j" . copy-to-repl-and-eval)
			  ("C-c C-e" . slime-eval-defun)))

(setq inferior-lisp-program "sbcl --dynamic-space-size 4Gb")
;; fast completion in sly repl
;; (add-hook 'sly-mode-hook (lambda () (setq-local corfu-auto-delay 0)))

(ag/use-package adjust-parens
  :defer t
  :hook ((lisp-mode emacs-lisp-mode) . adjust-parens-mode))

(defun sijo-test ()
  (interactive)
  ;; package version
  ;;(sly-eval-with-transcript `(sijo-doctest:test-package ,(read (sly-find-buffer-package)))))
  ;; file version
  ;; (sly-eval-with-transcript `(sijo-doctest:test-file ,(buffer-file-name (window-buffer (minibuffer-selected-window))))))
  ;; function version
  (sly-interactive-eval (print (concat "(progn (ql:quickload :sijo-doctest) (sijo-doctest:test \#'" (current-word) "))"))))

(ag/use-package ulisp-mode)

(ag/use-package ghostel
  :ensure t
  :config
  (when (eq system-type 'windows-nt)
    (add-to-list 'ghostel-tramp-shells '("plinkx" login-shell "/bin/bash"))
    (add-to-list 'ghostel-tramp-shells '("plink"  login-shell "/bin/bash")))
  (setq ghostel-shell-integration t
		ghostel-tramp-shell-integration t)
  (define-advice ghostel--write-remote-file (:around (orig path content) unix-eol)
    "Write remote files with LF line endings, even on Windows."
    (let ((coding-system-for-write
           (if (multibyte-string-p content) 'utf-8-unix 'binary)))
      (funcall orig path content))))

(ag/use-package eat
  :ensure nil
  :defer t
  :custom
  (eat-kill-buffer-on-exit t)
  (eat-line-input-history-isearch 'dwim)
  :config
   ; make C-u work in Eat terminals like in normal terminals
  (push [?\C-t] eat-semi-char-non-bound-keys)
  (push [?\C-b] eat-semi-char-non-bound-keys)
  (eat-update-semi-char-mode-map)
  ;; XXX: Awkward workaround for the need to call eat-reload after changing Eat's keymaps,
  ;; but reloading from :config section causes infinite recursion because :config wraps with-eval-after-load.
  (defvar eat--prevent-use-package-config-recursion nil)
  (unless eat--prevent-use-package-config-recursion
    (setq eat--prevent-use-package-config-recursion t)
    (eat-reload))
  (makunbound 'eat--prevent-use-package-config-recursion))

(defun bash-eat ()
  "Spawn an eat terminal running /bin/bash."
  (interactive)
  (eat "/bin/bash"))

;; (ag/use-package julia-snail
;;   :ensure t
;;   :custom
;;   (julia-snail-terminal-type :eat)
;;   :hook
;;   (julia-mode . julia-snail-mode)
;;   :bind (:map julia-snail-mode-map
;; 			  ("C-M-x" . julia-snail-send-dwim)
;; 			  ("C-c C-e" . julia-snail-send-line)
;; 			  ("C-c C-l" . julia-snail-send-buffer-file)))

;; fortran
(ag/use-package f90
  :bind (:map f90-mode-map
			  ("C-c C-c" . compile)))

(ag/use-package markdown-mode
  :ensure t)

(ag/use-package magit
  :ensure t
  :defer t)

(ag/use-package forge
  :ensure t
  :defer t
  :after magit)

(ag/use-package cdlatex
  :ensure t)

(ag/use-package auctex
  :config
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
		TeX-source-correlate-start-server t)
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  :hook
  (TeX-mode . TeX-source-correlate-mode))

(ag/use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(ag/use-package yeetube)

;;OTHER CONFIGS
;; slow down the insane scrolling
(setq mouse-wheel-scroll-amount '(3 ((shift) . 5) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
;; and the weird jumping
(setq scroll-conservatively 101)
(setq scroll-margin 1)

;;encoding
(when (eq system-type 'windows-nt)
  (setq-default buffer-file-coding-system 'utf-8-dos)
  (prefer-coding-system 'utf-8-dos))

;; y-n only
(defalias 'yes-or-no-p 'y-or-n-p)
;; don't ask when killing processes
(setq confirm-kill-processes nil)
(setq kill-buffer-query-functions nil)

;;indendation
(setq-default tab-width 4)

;;make file displays sorting case-insensitive
(ag/use-package ls-lisp
  :if (eq system-type 'windows-nt)
  :custom
  (ls-lisp-emulation 'MS-Windows)
  (ls-lisp-ignore-case t)
  (ls-lisp-use-insert-directory-program nil)
  (ls-lisp-use-string-collate nil))

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

;; fix grep/find: `find-program' is set from local.el when needed

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; fix turkish searching
(ag/use-package char-fold
  :config
  (setq search-default-mode 'char-fold-to-regexp)
  (setq replace-char-fold t)
  (push '(?ı "i") char-fold-include)
  (push '(?i "İ") char-fold-include)
  (char-fold-update-table))

(ag/use-package flycheck-grammarly
  :config
  (flycheck-grammarly-setup))

(defun asciify (str)
  "Return the asciified version of STR which contains Turkish characters."
  (with-temp-buffer
	(insert str)
	(turkish-asciify-buffer)
	(buffer-string)))

(ag/use-package wasabi
  :ensure t
  :vc (:url "https://github.com/moneylobster/wasabi"
			:rev :newest)
  :bind
  (:map wasabi-chat-mode-map
		("C-q" . #'bury-buffer))
  :custom
  (wasabi-message-notification-function
   (lambda (message)
	 (alert
      (if (map-elt message :is-reaction)
          (let ((target (wasabi--get-msg-content (map-elt message :target-id))))
			(concat (if target
						(concat "Reacted to " (substring-no-properties target))
                      "Reacted")
					" with: " (map-elt message :emoji)))
		(map-elt message :content))
      :title (map-elt message :sender-name)
      :category 'wasabi
      :icon (or ag/wasabi-icon
                (expand-file-name "elpa/wasabi/icon/wasabi.png"
                                  user-emacs-directory))
      :severity 'normal))))

;;; org stuff
(add-hook 'org-mode-hook
		  (lambda ()
			(local-set-key (kbd "M-}") 'org-next-visible-heading)
			(local-set-key (kbd "M-{") 'org-previous-visible-heading)
			(local-set-key (kbd "M-_") 'org-down-element)
			(local-set-key (kbd "M-+") 'org-up-element)))

;; Org Modern
(ag/use-package org-modern
  :ensure t
  :hook
  ;; (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(add-hook 'org-mode-hook #'org-cdlatex-mode)

(ag/use-package org-download
  :ensure t)

;; org roam
(ag/use-package org-roam
  :defer t
  :bind
  (:map org-mode-map :package org
		("C-c l" . #'org-roam-node-insert)
		("C-c b m" . #'org-roam-ui-mode))
  :config
  (when (file-directory-p org-roam-directory)
    (org-roam-db-autosync-mode)))

(ag/use-package org-roam-ui)

(ag/use-package org-timegrid
  :ensure t
  :commands (org-timegrid-week)
  :config
  (setq org-timegrid-org-tag-color-alist
		'(("proctor" . teal)
		  ("meeting" . yellow)
		  ("class" . green)
		  ("exam" . red)
		  ("quiz" . red)))
  (setq org-timegrid-time-format '24h))

(defun ag/agenda-dwim (arg)
	(interactive "P")
	(if arg
		(call-interactively 'org-timegrid-week)
	  (call-interactively 'org-agenda)))

(ag/use-package org-wild-notifier
  :ensure t
  :config
  (org-wild-notifier-mode))

;; citar for citations
(ag/use-package citar
  :ensure t
  :custom
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  (org-cite-export-processors
   '((latex . (csl "ieee.csl"))
	 ;; (html . (csl "ieee.csl"))
	 ;; (html . (csl "apa.csl"))
	 (html . (basic))
	 ))
	 
  (citar-bibliography org-cite-global-bibliography)
  
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup)
  :bind
  (:map org-mode-map :package org
		("C-c b b" . #'citar-insert-citation)
		("C-c b r" . #'citar-insert-reference)
		("C-c b o" . #'citar-open-notes)
		("C-c b f" . #'citar-open-files)))
		
(ag/use-package citar-org-roam
  :ensure t
  :after (citar org-roam)
  :custom
  (citar-org-roam-subdir "paper_notes")
  (citar-org-roam-note-title-template "${author} - ${title}")
  (org-roam-capture-templates
   '(("d" "default" plain
	  "%?"
	  :target
	  (file+head
	   "%<%Y%m%d%H%M%S>-${slug}.org"
	   "#+title: ${note-title}\n")
	  :unnarrowed t)
	 ("n" "literature note" plain
		 "%?"
		 :target
		 (file+head
		  "%(expand-file-name (or citar-org-roam-subdir \"\") org-roam-directory)/${citar-citekey}.org"
		  "#+title: ${citar-citekey} (${citar-date}). ${note-title}.\n#+created: %U\n#+last_modified: %U\n#+read: no\n\n")
		 :unnarrowed t)))
  (citar-org-roam-capture-template-key "n")
  :config (citar-org-roam-mode))

;; (ag/use-package org-fragtog
;;   :ensure t
;;   :defer t
;;   :init
;;   (add-hook 'org-mode-hook 'org-fragtog-mode))

(ag/use-package latex-to-svg-for-org
  :ensure t
  :custom
  (latex-to-svg-frontend-engine 'ratex)
  (latex-to-svg-frontend-detect-dollar-inline nil)    ; $ ... $
  (latex-to-svg-frontend-detect-dollar-display nil)   ; $$ ... $$
  :hook (org-mode . latex-to-svg-for-org-mode))

(defun latex-math-from-calc ()
  "Evaluate `calc' on the contents of line at point."
  (interactive)
  (cond ((region-active-p)
         (let* ((beg (region-beginning))
                (end (region-end))
                (string (buffer-substring-no-properties beg end)))
           (kill-region beg end)
           (insert (calc-eval `(,string calc-language latex
                                        calc-prefer-frac t
                                        calc-angle-mode rad)))))
        (t (let ((l (thing-at-point 'line)))
             (end-of-line 1) (kill-line 0)
             (insert (calc-eval `(,l
                                  calc-language latex
                                  calc-prefer-frac t
                                  calc-angle-mode rad)))))))

(with-eval-after-load 'org (define-key org-mode-map (kbd "C-S-r") 'latex-math-from-calc))
(with-eval-after-load 'org (add-to-list 'org-file-apps '("\\.pdf\\'" . emacs)))

(ag/use-package ob-mermaid
  :custom
  (ob-mermaid-cli-path "mmdc"))

;; Function to archive DONE tasks in org mode
(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
	 (org-archive-subtree)
	 (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'file))

(ag/use-package ox-latex
  :defer t
  :config
  (add-to-list 'org-latex-packages-alist '("" "float" nil))
  ;; (add-to-list 'org-latex-packages-alist '("left=2cm, right=2cm, top=3cm, bottom=3cm" "geometry" nil))
  (add-to-list 'org-latex-packages-alist '("" "svg"))
  (add-to-list 'org-latex-packages-alist '("" "amsmath"))
  ;; syntax highlighting in org pdf exports
  (add-to-list 'org-latex-packages-alist '("" "minted" nil))
  (setq org-latex-listings 'minted)
  (setq org-latex-minted-options '(("breaklines" "true")))
  
  (setq org-latex-pdf-process
		'("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
		  "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
		  "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f")))

;; get a minified org-agenda view
(setq org-agenda-custom-commands
	  '(("n" "Agenda and all TODOs"
		 ((agenda #1="")
		  (alltodo #1#)))
		("P" "Printout"
		 ((agenda "" ((org-agenda-span 1)
					  (org-deadline-warning-days 7)
					  (org-agenda-scheduled-leaders '("" ""))
					  (org-agenda-prefix-format "%t%s")
					  (org-agenda-skip-scheduled-if-done t))))
					  
		 ((org-agenda-with-colors nil)
		  (org-agenda-compact-blocks t)
		  (org-agenda-remove-tags t)
		  (org-agenda-use-time-grid nil)))))
		  
;; org publish org-roam wiki
(setq org-publish-project-alist
	  '(("orgroam-wiki"
		 :base-directory ag/roam-directory
		 :recursive t
		 :publishing-function org-html-publish-to-html
		 :publishing-directory ag/wiki-directory
		 :with-toc nil
		 :section-numbers t
		 :html-head "<!-- both css files below use the MIT license -->
  <link rel=\"stylesheet\" href=\"https://unpkg.com/normalize.css\">
  <link rel=\"stylesheet\" href=\"https://unpkg.com/concrete.css\">
  <!-- additional bit of CSS to make code readable in dark mode -->
  <style> pre {background-color: inherit;} </style>
<!-- collapsibility, modified from https://emacs.stackexchange.com/questions/53651/cannot-export-org-mode-to-collapsible-html -->
<script type=\"module\">
   function collapse() {
		var title = this
		var content = this.parentNode
		var children = content.children
		for (var i=0; i<children.length; i++) {
			var c = children[i]
			if (c !== title) {
				c.style.display = c.style.display === \"none\" ? \"block\" : \"none\"
			} else {
				c.textContent = c.textContent.slice(-3) === \"...\" ?  c.textContent.slice(0,-3) : c.textContent+\"...\"
			}
		}
  }
  function collapseall() {
	  document.querySelectorAll(\"h2, h3, h4, h5, h6\").forEach(function(heading) {
		  collapse.call(heading)
	  })
  }
	document.querySelectorAll(\"h2, h3, h4, h5, h6\").forEach(function(heading) {
		heading.addEventListener(\"click\", collapse)
	})
  document.onkeydown = function (e) {
	  e = e || window.event;
	  switch (e.which || e.keyCode) {
      case 69:
		  collapseall();
          break;
	  }
  }
  collapseall()
</script>
  <!-- add cat to website -->
  <script>NekoType=\"white\"</script>
  <h1 id=nl><script src=\"https://webneko.net/n20171213.js\"></script><a 
  href=\"https://webneko.net\">Neko</a></h1>"
		 :html-validation-link nil
		 :html-link-home ag/wiki-home-url
		 :html-link-up ag/wiki-up-url
		 :html-home/up-format "<div id=\"org-div-home-and-up\">
 <a accesskey=\"h\" href=\"%s\"> WIKI </a>
 |
 <a accesskey=\"H\" href=\"%s\"> HOME </a>
</div>"
		 :auto-sitemap t
		 :sitemap-title "Wiki Sitemap")))

(when (and ag/publishwiki-file (file-exists-p ag/publishwiki-file))
  (load ag/publishwiki-file nil t))
  
(ag/use-package org-pomodoro
  :bind (:map org-agenda-mode-map
			  ("M-p" . org-pomodoro)))

(ag/use-package org-alert)

(ag/use-package org-tanglesync
  :defer t)

(ag/use-package org-natural-date
  :if (locate-library "org-natural-date")
  :after org
  :config (org-natural-date-mode 1))

(defun org-babel-detangle-no-buffer-pop-up (orig-fun &rest args)
  (save-excursion
    (let ((display-buffer-alist
           '((".*" (display-buffer-no-window) (allow-no-window . t)))))
      (apply orig-fun args))))

(advice-add 'org-babel-detangle :around #'org-babel-detangle-no-buffer-pop-up)

;; org macros
(defun ag/org-figure (file name caption)
  "insert boilerplate text for figure."
  (interactive "FImage File: \nsName: \nsCaption: ")
  (insert "#+CAPTION: " caption "
#+NAME: fig:" name "
#+ATTR_LATEX: :width 350px :placement [H]
[[" file "]]"))
  

;; IOT calendar communication
;; gets most recent tasks/events starting from line 1
(defun ag/org-agenda-line-get (lineno)
  (save-window-excursion
	(pop-to-buffer "agenda")
	(org-agenda nil "P")
	(prog1 (if (nth lineno (split-string (buffer-string) "\n"))
			   (substring-no-properties (nth lineno (split-string (buffer-string) "\n"))))
	  (kill-buffer "agenda"))))
  


(defun convert-list-to-string (list)
  "Convert LIST to string."
  (let* ((string-with-parenthesis (format "%S" list))
		 (end (- (length string-with-parenthesis) 1)))
	(substring string-with-parenthesis 1 end)))

(defvar cal-server-port 50234
  "port of the calendar server")

(defvar cal-server-clients '() 
  "alist where KEY is a client process and VALUE is the string")


(defun cal-server-start nil
  "starts an emacs calendar server"
  (interactive)
  (unless (process-status "cal-server")
	(make-network-process :name "cal-server" :buffer "*cal-server*" :family 'ipv4 :service cal-server-port :sentinel 'cal-server-sentinel :filter 'cal-server-filter :server 't :host "0.0.0.0" :noquery t)
	(setq cal-server-clients '())))
	
  

(defun cal-server-stop nil
  "stop an emacs calendar server"
  (interactive)
  (while  cal-server-clients
	(delete-process (car (car cal-server-clients)))
	(setq cal-server-clients (cdr cal-server-clients)))
  (delete-process "cal-server"))
  

(defun cal-server-filter (proc string)	 
  (let ((pending (assoc proc cal-server-clients))
		message
		index)
	;;create entry if required
	(unless pending
	  (setq cal-server-clients (cons (cons proc "") cal-server-clients))
	  (setq pending	 (assoc proc cal-server-clients)))
	(setq message (concat (cdr pending) string))
	(while (setq index (string-match "\n" message))
	  (setq index (1+ index))
	  (setq stringcut (substring string 0 3))
	  (if (string= stringcut "clk")
		  ;;send time here
		  (progn
			(setq ag/timevar (decode-time (current-time)))
			(setq ag/newtimevar
				  (string-join 
				   (list
					(format "%02d" (nth 2 ag/timevar))
					(format "%02d" (nth 1 ag/timevar))
					(format "%02d" (nth 0 ag/timevar))
					(format "%d"   (nth 6 ag/timevar))
					(format "%02d" (nth 3 ag/timevar))
					(format "%02d" (nth 4 ag/timevar))
					(format "%02d" (% (nth 5 ag/timevar) 100))) " "))
			(cal-server-log	 (concat (convert-list-to-string ag/newtimevar) "\n"))
			(process-send-string proc (concat (convert-list-to-string ag/newtimevar) "\0\n")))
		(if (string= stringcut "dl1")
			;;send line1 here
			(process-send-string proc (concat "x " (ag/org-agenda-line-get 1) "\0\n"))
		  (if (string= stringcut "dl2")
			  ;;send line2 here
			  (process-send-string proc (concat "x " (ag/org-agenda-line-get 2) "\0\n"))
			(if (string= stringcut "dl3")
				;;send line3 here
				(process-send-string proc (concat "x " (ag/org-agenda-line-get 3) "\0\n"))
			  (if (string= stringcut "dl4")
				  ;;send line4 here
				  (process-send-string proc (concat "x " (ag/org-agenda-line-get 4) "\0\n"))
				(process-send-string proc "unsupported command \0"))))))
				
	  (cal-server-log  (substring message 0 index) proc)
	  (setq message (substring message index)))
	(setcdr pending message)))
  

(defun cal-server-sentinel (proc msg)
  (when (string= msg "connection broken by remote peer\n")
	(setq cal-server-clients (assq-delete-all proc cal-server-clients))
	(cal-server-log (format "client %s has quit" proc))))

;;from server.el
(defun cal-server-log (string &optional client)
  "If a *cal-server* buffer exists, write STRING to it for logging purposes."
  (if (get-buffer "*cal-server*")
	  (with-current-buffer "*cal-server*"
		(goto-char (point-max))
		(insert (current-time-string)
				(if client (format " %s:" client) " ")
				string)
		(or (bolp) (newline)))))

(message "Calendar server is NOT launched at startup currently.")
;; (add-hook 'dashboard-after-initialize
;; 		  (condition-case nil
;; 			  (cal-server-start)
;; 			(error (kill-buffer "*cal-server*"))))

(defun ag/dashboard-refresh-buffer nil
  (interactive)
  (when (fboundp 'ag/moodle-sync)
    (ignore-errors (ag/moodle-sync)))
  (dashboard-refresh-buffer)
  (cd ag/dashboard-directory))
  

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

;; call LLM
(defun insert-after-region-filter (proc string)
  (when (buffer-live-p (process-buffer proc))
	(with-current-buffer (process-buffer proc)
	  (let ((moving (= (point) (process-mark proc))))
		(save-excursion
		  ;; Insert the text, advancing the process marker.
		  (goto-char (process-mark proc))
		  (insert string)
		  (set-marker (process-mark proc) (point)))
		(if moving (goto-char (process-mark proc)))))))

(defun ag/llm (&optional beginning end)
  "call local llm"
  (interactive "r")
  (if (use-region-p)
	  (if (equal current-prefix-arg nil) ; if there is a C-u, call the 13B model. Not sure how to do this without repetition in lisp yet.
	   (let ((proc (make-process :name "llm" :buffer (current-buffer) :command (list "llm" (buffer-substring-no-properties beginning end)) :filter 'insert-after-region-filter :sentinel #'ignore)))
		 (set-marker (process-mark proc) end)
		 (delete-region beginning end))
		
	   (let ((proc (make-process :name "llm" :buffer (current-buffer) :command (list "llm" "-m13" (buffer-substring-no-properties beginning end)) :filter 'insert-after-region-filter :sentinel #'ignore)))
		 (set-marker (process-mark proc) end)
		 (delete-region beginning end)))
	(message "No region selected.")))

(ag/use-package herdr-core
  :if (locate-library "herdr-core")
  :config
  (global-set-key (kbd "<f8> h") 'herdr-core-dashboard))

(ag/use-package gptel
  :ensure t
  :defer t
  :config
  (defconst ag/gptel-org-directive
	"You are an assistant writing directly into an Emacs Org-mode buffer. Your reply must be valid Org, never Markdown.

Structure:
- Every heading in your reply starts with two or more stars and a space. A line starting with one star is an error.
- Heading level never goes up inside one reply: once you use \"**\", every later heading is \"**\" or deeper.
- Do not wrap the whole reply in a heading such as \"Answer\" or \"Summary\". Begin with the answer itself, or with a heading that names the topic.
- Use a heading for each distinct section of a long answer. Do not flatten a sectioned answer into one long bullet list.
- Bullets start with \"- \" and are for lists, not for sections.

Formatting:
- Code, shell commands and paths go inside source blocks:
#+begin_src sh
ls -la
#+end_src
- Mathematics is LaTeX in the text, not inside source blocks: inline \\( ... \\), display \\[ ... \\]. Never delimit math with dollar signs.
- No bold, italic or underline anywhere, and no inline markup around code or paths.
- Tables are Org tables with at most 3 columns, every row within 70 characters; otherwise use bullets.
- Answer first, stop when done: no preamble, no recap, no follow-up offers.

Example for the question \"what is the derivative of x squared?\":

The derivative of \\(x^2\\) is \\(2x\\).

\\[
\\frac{d}{dx} x^2 = 2x
\\]

Example for the question \"compare vectors and matrices\":

** Vectors
An ordered list of numbers with a magnitude.

** Matrices
A rectangular array that acts on vectors.

Be concise. Use Eval only when needed, batch it into one call, and comment each step.")
  (setq gptel-directives
        `((default . ,ag/gptel-org-directive)
          (programming
           . "You are a large language model and a careful programmer. Provide code and only code as output without any additional text, prompt or note.")
          (writing
           . "You are a large language model and a writing assistant. Respond concisely.")
          (chat
           . "You are a large language model and a conversation partner. Respond concisely.")))
  (setq gptel-system-prompt (alist-get 'default gptel-directives))
  (setq gptel-default-mode 'org-mode)
  (setq gptel-include-reasoning nil)
  (setq gptel-org-convert-response nil)
  (setf (alist-get 'org-mode gptel-prompt-prefix-alist) "* ")
  (setq gptel-model 'deepseek/deepseek-v4.1-flash-1017
		gptel-backend (gptel-make-openai "OpenRouter"
						:host "openrouter.ai"
						:endpoint "/api/v1/chat/completions"
						:stream t
						:key #'gptel-api-key-from-auth-source
						:models '(deepseek/deepseek-v4.1-flash-1017)))
  (setf (get 'deepseek/deepseek-v4.1-flash-1017 :request-params)
		'(:reasoning (:effort "low")))
  (gptel-make-preset 'high-think
	:model 'deepseek/deepseek-v4.1-flash-1017
	:request-params '(:reasoning (:effort "high"))))

(defun ag/gptel-dwim (arg)
  (interactive "P")
  (if arg
	  (call-interactively 'gptel)
	  (gptel-send '(4))))

(ag/use-package gptel-agent
  :ensure t
  :after gptel
  :config
  (setq gptel-tools (mapcar 'gptel-get-tool '("WebSearch" "WebFetch" "Eval"))))

(ag/use-package gptel-annotate
  :vc (:url "https://github.com/karthink/gptel-annotate"
       :rev :newest)
  :after gptel)

(ag/use-package gptel-openrouter
  :vc (:url "https://github.com/bharadswami/gptel-openrouter"
			:rev :newest)
  :after gptel
  :config
  (setq gptel-backend (gptel-openrouter-make-backend "OpenRouter"
						:key #'gptel-api-key-from-auth-source
						:stream t)))

(ag/use-package ag-gptel-tools
  :if (locate-library "ag-gptel-tools")
  :after gptel
  :config
  (setq gptel-tools (append gptel-tools (list (gptel-get-tool "ReadPDF")))))



(ag/use-package flyover
  :ensure t
  :hook ((flycheck-mode . flyover-mode)
         (flymake-mode . flyover-mode))
  :custom
  ;; Checker settings
  (flyover-checkers '(flycheck flymake))
  (flyover-levels '(error warning info))

  ;; Appearance
  (flyover-use-theme-colors t)
  (flyover-background-lightness 45)

  ;; Text tinting
  (flyover-text-tint 'lighter)
  (flyover-text-tint-percent 50)

  ;; Icon tinting (foreground and background)
  (flyover-icon-tint 'lighter)
  (flyover-icon-tint-percent 50)
  (flyover-icon-background-tint 'darker)
  (flyover-icon-background-tint-percent 50)

  ;; Icons
  (flyover-info-icon "i")
  (flyover-warning-icon "!")
  (flyover-error-icon "E")

  ;; Border styles: none, pill, arrow, slant, slant-inv, flames, pixels
  (flyover-border-style 'pill)
  (flyover-border-match-icon t)

  ;; Display settings
  (flyover-hide-checker-name t)
  (flyover-show-virtual-line t)
  (flyover-virtual-line-type 'curved-dotted-arrow)
  (flyover-line-position-offset 1)

  ;; Message wrapping
  (flyover-wrap-messages t)
  (flyover-max-line-length 80)

  ;; Performance
  (flyover-debounce-interval 0.2)
  (flyover-cursor-debounce-interval 0.3)

  ;; Display mode (controls cursor-based visibility)
  (flyover-display-mode 'always)

  ;; Completion integration
  (flyover-hide-during-completion t))

(ag/use-package anki-editor
  :vc (:url "https://github.com/anki-editor/anki-editor" :rev :newest))

(ag/use-package grading-mode
  :if (locate-library "grading-mode"))

(defun ag/run-llama ()
  "Start a llama-cpp server with the gemma model."
  (interactive)
  (async-shell-command "llama-server -hf ggml-org/gemma-3-4b-it-qat-GGUF -c 0 --jinja --context-shift"))

(defun ag/sync nil
  "sync org files with mobile"
  (interactive)
  (shell-command "orgsync &"))
  

(defun ag/fullscreen nil
  "fullscreen shows clock and battery"
  (interactive)
  (progn
	(toggle-frame-fullscreen)
	(display-battery-mode 'toggle)
	(display-time-mode 'toggle)
	(toggle-menu-bar-mode-from-frame 'toggle)))
	



(defun ag/org-presentation-beamer ()
  (interactive)
  (insert "#+AUTHOR:" (user-full-name) "
#+STARTUP: beamer
#+LATEX_CLASS: beamer
#+latex_header: \\AtBeginSection[]{\\begin{frame}<beamer>\\frametitle{Topic}\\tableofcontents[currentsection]\\end{frame}} \setbeamertemplate{footline}[frame number]
#+OPTIONS: H:2
#+CITE_EXPORT: csl apa.csl
"))

(defun ag/org-report ()
  (interactive)
  (insert "#+AUTHOR:" (user-full-name) "
#+LATEX_HEADER: \\usepackage{float}
#+LATEX_HEADER: \\usepackage[left=2cm, right=2cm, top=3cm, bottom=3cm]{geometry}
#+LATEX_HEADER: \\usepackage{amsmath}
#+PROPERTY: header-args :eval never-export"))

(defun ag/mystery-hour ()
  "Pick a random project to work on."
  (interactive)
  (let ((projectlist '("cl-symbolic"
					   "cl-robotics"
					   "the newsletter"
					   "grandpunk time clock"
					   "reading books"
					   "PAIP"
					   "multimeter watch"
					   "transcribe"
					   "cl-fmu"
					   "cl-controls")))
	(message "Work on: %s" (print (nth (random (length projectlist)) projectlist)))))

(defun ag/pomodoro ()
  "Start a 25 min timer."
  (interactive)
  (org-timer-set-timer 25))

(defalias 'ftw-constant
   (kmacro "f t w : <delete> <delete> <delete> <right> + C-M-S-<right> M-% _ <return> - <return> ! C-M-<right> C-r : <return> <right> <right> C-M-S-<right> C-x C-l +"))


(defun unpackaged/eww-imenu-index ()
  "Return Imenu index for current EWW buffer.
Index includes links and headings."
  (let ((shr-heading-faces '( shr-h1 shr-h2 shr-h3 shr-h4 shr-h5
                              shr-h6 shr-heading)))
    (cl-labels ((range-matching (property predicate)
                  "Return (BEG . END) cons from point where PROPERTY matches PREDICATE.
  PREDICATE is used for `text-property-search-forward', which see."
                  (when-let ((match (text-property-search-forward property nil predicate))
                             (end (cl-loop
                                   for next-change-pos = (prop-match-end match) then next-change-pos
                                   for next-change-pos = (next-single-property-change next-change-pos property)
                                   when next-change-pos
                                   for end-pos = next-change-pos
                                   while (funcall predicate nil (get-text-property next-change-pos property))
                                   finally return end-pos)))
                    (cons (prop-match-beginning match) end)))
                (shr-heading-p (_ value-of)
                  (cl-typecase value-of
                    (atom (member value-of shr-heading-faces))
                    (list (seq-intersection value-of shr-heading-faces)))))
      (let ((links (save-excursion
                     (goto-char (point-min))
                     (delete-dups
                      (cl-loop for url = (get-text-property (point) 'shr-url)
                               when url collect (cons (format "%s <%s>"
                                                              (button-label (button-at (point)))
                                                              url)
                                                      (point))
                               for pos = (next-single-property-change (point) 'shr-url)
                               while pos do (goto-char pos)))))
            (headings (save-excursion
                        (goto-char (point-min))
                        (cl-loop for (next-beg . next-end) = (range-matching 'face #'shr-heading-p)
                                 while next-beg
                                 for text = (buffer-substring next-beg next-end)
                                 collect (cons text next-beg)
                                 and do (goto-char next-end)))))
        (list (cons "Headings" headings)
              (cons "Links" links))))))

(defun unpackaged/eww-imenu-goto (_label position)
  "Go to POSITION and call `eww-follow-link' if one is there."
  (goto-char position)
  (when (button-at (point))
    (declare-function eww-follow-link "eww")
    (call-interactively #'eww-follow-link)))

(defun unpackaged/eww-imenu-setup ()
  "Setup Imenu in EWW buffers."
  (setq-local imenu-create-index-function #'unpackaged/eww-imenu-index
              imenu-default-goto-function #'unpackaged/eww-imenu-goto))

(add-hook 'eww-mode-hook #'unpackaged/eww-imenu-setup)


(defun ag/webm-to-mp4 ()
  "Convert webms to Whatsapp-compatible mp4s."
  (interactive)
  (dwim-shell-command-on-marked-files
   "Convert to mp4"
   "ffmpeg -i \"<<f>>\" -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p \"<<fne>>.mp4\""
   :utils "ffmpeg"))

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
(global-set-key (kbd "M-w") 'back-to-indentation)
(global-set-key (kbd "C-t") 'tab-switch)
(global-set-key (kbd "C-b") 'switch-to-buffer)
(global-set-key (kbd "C-M-q") 'counsel-imenu)
(global-set-key (kbd "<f7>") 'ag/agenda-dwim)
(global-set-key (kbd "<f8> p") 'citar-open-files)
(global-set-key (kbd "<f8> o") 'citar-open-notes)
(global-set-key (kbd "<f8> a") (lambda () (interactive) (arxiv-read-new 'cs.RO)))
(which-key-add-key-based-replacements "<f8> a" "arxiv-new-RO")
(global-set-key (kbd "<f8> w") 'wasabi)
(global-set-key (kbd "<f8> g") 'gnus)
(global-set-key (kbd "<f8> i") 'erc-tls)
(global-set-key (kbd "<f8> f") 'elfeed)
(global-set-key (kbd "<f8> c") 'calc)
(global-set-key (kbd "<f9>") 'ag/gptel-dwim)
(global-set-key (kbd "<f11>") 'ag/fullscreen)
(global-set-key (kbd "<f12>") 'ghostel)
(global-set-key (kbd "C-<f12>") 'ivy-resume)
(global-set-key (kbd "C-<tab>") 'next-window-any-frame)
(global-set-key (kbd "C-S-<tab>") 'previous-window-any-frame)
(global-set-key (kbd "C-x C-r") 'recentf)
(when (fboundp 'open-in-windows-open)
  (global-set-key (kbd "C-x f") 'open-in-windows-open))
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
(global-set-key (kbd "<C-M-wheel-up>") 'ignore)
(global-set-key (kbd "<C-M-wheel-down>") 'ignore)

;; start emacs server
(require 'server)
(add-hook 'dashboard-after-initialize-hook (lambda () (unless (server-running-p)
														(server-start))))
(put 'set-goal-column 'disabled nil)

(add-hook 'kill-emacs-hook
          (lambda ()
            (dolist (p (process-list))
              (set-process-query-on-exit-flag p nil)
              (ignore-errors (delete-process p)))))
