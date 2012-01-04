; Public Domain (-) 2000-2011 tav <tav@espians.com>

(require 'cl)

(setq user-full-name "tav")
(setq user-mail-address "tav@espians.com")

; ------------------------------------------------------------------------------
; Self Load
; ------------------------------------------------------------------------------

(defun dot-emacs() "Open my .emacs file" (interactive)
  (find-file "~/.emacs.d/init.el"))

; ------------------------------------------------------------------------------
; Extend Load Path
; ------------------------------------------------------------------------------

(add-to-list 'load-path "~/.emacs.d/packages/")
(add-to-list 'load-path "~/.emacs.d/code/html5-el/")

; ------------------------------------------------------------------------------
; Aquamacs Fix
; ------------------------------------------------------------------------------

(custom-set-variables
 '(aquamacs-version-check-url nil)
 '(aquamacs-scratch-file nil))

(aquamacs-autoface-mode nil)

(setq magic-mode-alist ()) ; Disable the loading of the html-helper-mode crap
						   ; based on content-sniffing

; ------------------------------------------------------------------------------
; Utility Functions
; ------------------------------------------------------------------------------

(defun strip-string (str)
  "Strip any leading/trailing whitespace from the given string"
  (replace-regexp-in-string "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" "" str))

(defun get-git-repo-name ()
  "Get the name of any enclosing git repositories"
  (let ((repo
		 (ignore-errors (process-lines "git" "rev-parse" "--show-toplevel"))))
	(if (equal repo nil) 
		""
	  (message (car (last (split-string (strip-string (car repo)) "/")))))))

(defun get-git-repo-title ()
  "Get the normalised title of any enclosing git repositories"
  (mapconcat 'capitalize (split-string (get-git-repo-name) "-") ""))

(defun get-public-domain-header ()
  ""
  (let ((title (get-git-repo-title)) (sep (strip-string comment-start)))
	(mapconcat 'identity
			   (list sep
					 " Public Domain (-) "
					 (substring (current-time-string) 20 24)
					 " The "
					 title
					 " Authors.
"
					 sep
					 " See the "
					 title
					 " UNLICENSE file for details."
				   )
			   "")))

; ------------------------------------------------------------------------------
; General Settings
; ------------------------------------------------------------------------------

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

(setq kill-whole-line t)
(setq require-final-newline nil)

(set-language-environment 'utf-8)

; ------------------------------------------------------------------------------
; Minimal UI
; ------------------------------------------------------------------------------

(defun setup-windowed-interface () "Setup the windowed interface"
  (setq confirm-kill-emacs 'y-or-n-p)
  (setq frame-background-mode 'dark)
  (setq default-frame-alist
		'((wait-for-wm . nil)
		  (top . 30) (left . 820)
		  (width . 110) (height . 60)
		  (alpha . 73)
		  (font . "-apple-monaco-medium-r-normal--14-140-72-72-m-140-iso10646-1")
		  )))

(if window-system
	(setup-windowed-interface))

(if (equal window-system nil)
	(menu-bar-mode nil))

(column-number-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(line-number-mode t)
(scroll-bar-mode nil)
(show-paren-mode t)
(tool-bar-mode 0)

(setq frame-title-format '("%b" (buffer-file-name ": %f")))
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq visible-bell t)

(setq display-time-day-and-date t)
(display-time)

; ------------------------------------------------------------------------------
; Auto-completion
; ------------------------------------------------------------------------------

(require 'hippie-exp)

(setq hippie-expand-try-functions-list
	  '(try-expand-all-abbrevs
		try-expand-list
		try-expand-dabbrev
		try-expand-dabbrev-all-buffers
		try-expand-dabbrev-from-kill
		ispell-complete-word))

(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dicts")
(ac-config-default)
(global-auto-complete-mode t)

; ------------------------------------------------------------------------------
; Auto-pairing
; ------------------------------------------------------------------------------

(require 'autopair)

(autopair-global-mode)

; ------------------------------------------------------------------------------
; Bookmarks
; ------------------------------------------------------------------------------

(setq bookmark-default-file "~/.emacs.d/bookmarks")
(setq bookmark-save-flag 1)

; ------------------------------------------------------------------------------
; Buffer Cleanup
; ------------------------------------------------------------------------------

(require 'midnight)

(setq clean-buffer-list-delay-general 2)

; ------------------------------------------------------------------------------
; Colour Theme
; ------------------------------------------------------------------------------

(require 'color-theme)

(setq color-theme-is-global t)

; ------------------------------------------------------------------------------
; Diminish Mode
; ------------------------------------------------------------------------------

(require 'diminish)

(eval-after-load "auto-complete" '(diminish 'auto-complete-mode))
(eval-after-load "autopair" '(diminish 'autopair-mode))
(eval-after-load "flyspell" '(diminish 'flyspell-mode))
(eval-after-load "hideshow" '(diminish 'hs-minor-mode))
; (eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
(eval-after-load "yasnippet" '(diminish 'yas/minor-mode))

; ------------------------------------------------------------------------------
; Emacs Client
; ------------------------------------------------------------------------------

(unless (server-running-p)
  (server-start))

; ------------------------------------------------------------------------------
; GitHub
; ------------------------------------------------------------------------------

(require 'gist)

; ------------------------------------------------------------------------------
; Footnotes
; ------------------------------------------------------------------------------

(setq footnote-start-tag "[")
(setq footnote-end-tag "]_")

; ------------------------------------------------------------------------------
; HideShow
; ------------------------------------------------------------------------------

(defun enable-hide-show() "Setup HideShow functionality" (interactive)
  (define-key (current-local-map) (kbd "<A-left>") 'hs-hide-block)
  (define-key (current-local-map) (kbd "<A-right>") 'hs-show-block)
  (define-key (current-local-map) (kbd "<A-up>") 'hs-show-all)
  (define-key (current-local-map) (kbd "<A-down>") 'hs-hide-all)
  (hs-minor-mode t))

; ------------------------------------------------------------------------------
; Ido
; ------------------------------------------------------------------------------

(require 'ido)

(ido-mode t)

; ------------------------------------------------------------------------------
; Ignore Paths
; ------------------------------------------------------------------------------

(setq completion-ignored-extensions
	  (append
	   (list
		"CVS/"
		".bzr/"
		".git/"
		".hg/"
		".svn/"
		"_obj/"
		".DS_STORE"
		".5"
		".6"
		".8"
		".a"
		".dylib"
		".egg"
		".jar"
		".la"
		".lo"
		".pyc"
		".pyo"
		".so"
		) completion-ignored-extensions))

(setq completion-ignore-case t)

; ------------------------------------------------------------------------------
; Narrowing
; ------------------------------------------------------------------------------

(put 'narrow-to-region 'disabled nil)

; ------------------------------------------------------------------------------
; Paging
; ------------------------------------------------------------------------------

(require 'pager)

; ------------------------------------------------------------------------------
; Search & Replace
; ------------------------------------------------------------------------------

(setq case-fold-search t) ; Ignore case when searching.

(setq search-whitespace-regexp "[ \t\r\n]+") ; Interpret line breaks as ordinary
											 ; spaces in incremental search.
(setq search-highlight t)
(setq query-replace-highlight t)

(require 'iedit)

; ------------------------------------------------------------------------------
; Shell Support
; ------------------------------------------------------------------------------

(add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m)
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

; ------------------------------------------------------------------------------
; Spacing
; ------------------------------------------------------------------------------

(setq default-fill-column 80)
(setq default-tab-width 4)
(setq indent-tabs-mode nil)
(setq sentence-end-double-space nil)

; Used by tab-to-tab-stop
; default in indent.el: '(8 16 24 32 40 48 56 64 72 80 88 96 104 112 120)

(setq tab-stop-list
	  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64
		  68 72 76 80 84 88 92 96 100 104 108 112 116 120))

(fset 'left-indent-4 "\C-a\C-d\C-d\C-d\C-d")

; ------------------------------------------------------------------------------
; Spellcheck
; ------------------------------------------------------------------------------

(setq flyspell-default-dictionary "en_GB")

; ------------------------------------------------------------------------------
; Text Init
; ------------------------------------------------------------------------------

(setq text-mode-hook
	  '(flyspell-mode turn-on-auto-fill text-mode-hook-identify))

; ------------------------------------------------------------------------------
; Text Manipulation
; ------------------------------------------------------------------------------

(defun join-paragraph ()
  ;; by David Goodger
  "Join lines in current paragraph into one line, removing end-of-lines."
  (interactive)
  (save-excursion
    (backward-paragraph 1)
    (forward-char 1)
    (let ((start (point)))	; remember where we are
      (forward-paragraph 1)	; go to the end of the paragraph
      (beginning-of-line 0)	; go to the beginning of the previous line
      (while (< start (point))	; as long as we haven't passed where we started
		(delete-indentation)	; join this line to the line before
		(beginning-of-line)))))	; and go back to the beginning of the line

(defun force-fill-paragraph ()
  ;; by David Goodger
  "Fill paragraph at point, first joining the paragraph's lines into one.
This is useful for filling list item paragraphs."
  (interactive)
  (join-paragraph)
  (fill-paragraph nil))

; ------------------------------------------------------------------------------
; Undo
; ------------------------------------------------------------------------------

; (require 'undo-tree)

; (global-undo-tree-mode)

; ------------------------------------------------------------------------------
; Unique Buffer Names
; ------------------------------------------------------------------------------

(require 'uniquify) 

(setq uniquify-after-kill-buffer-p t)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-ignore-buffers-re "^\\*")
(setq uniquify-separator " • ")

; ------------------------------------------------------------------------------
; Version Control
; ------------------------------------------------------------------------------

(add-to-list 'vc-handled-backends 'Git)

(autoload 'magit-status "magit" nil t)

(require 'diff-git)

; ------------------------------------------------------------------------------
; Yasnippet
; ------------------------------------------------------------------------------

(require 'yasnippet)

(yas/initialize)
(setq yas/root-directory "~/.emacs.d/snippets")

; ------------------------------------------------------------------------------
; C
; ------------------------------------------------------------------------------

(defun c-mode-custom ()
  "Custom hook for c-mode"
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (setq c-indent-level 4))

(add-hook 'c-mode-hook 'c-mode-custom)

(defun highlight-xxx () "Highlight special keywords"
  (interactive)
  (font-lock-add-keywords
   nil
   '(("\\(FIXME\\|TODO\\|BUG\\|XXX\\|@@\\)" 1 font-lock-warning-face t))))

(defun c-mode-common-custom ()
  "Custom hook for c-mode-derived modes"
  (highlight-xxx)
  (enable-hide-show))

(add-hook 'c-mode-common-hook 'c-mode-common-custom)

; ------------------------------------------------------------------------------
; CoffeeScript
; ------------------------------------------------------------------------------

(autoload 'coffee-mode "coffee-mode"
  "Major mode for editing CoffeeScript files" t)

(defun coffee-mode-custom ()
  "Custom hook for coffee-mode"
  (define-key coffee-mode-map [(meta r)] 'coffee-compile-buffer)
  (define-key coffee-mode-map [(meta R)] 'coffee-compile-file)
  (setq coffee-args-compile '("-c" "--bare"))
  (enable-hide-show)
  (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook 'coffee-mode-custom)

(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

; ------------------------------------------------------------------------------
; CSS
; ------------------------------------------------------------------------------

(autoload 'css-mode "css-mode"
  "Major mode for editing CSS files" t)

(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))

; ------------------------------------------------------------------------------
; Go
; ------------------------------------------------------------------------------

(autoload 'go-mode "go-mode"
  "Major mode for editing Go files" t)

(defun go-mode-custom()
  "Custom hook for go-mode"
  (define-key go-mode-map (kbd "A-\\") 'gofmt)
  (highlight-xxx)
  (enable-hide-show))

(add-hook 'go-mode-hook 'go-mode-custom)
(add-to-list 'auto-mode-alist '("\\.go$" . go-mode))

(require 'go-autocomplete)

; ------------------------------------------------------------------------------
; JavaScript
; ------------------------------------------------------------------------------

(autoload 'js2-mode "js2-mode"
  "Major mode for editing JavaScript files" t)

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

(defun js2-mode-custom ()
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (highlight-xxx)
  (enable-hide-show))

(add-hook 'js2-mode-hook 'js2-mode-custom)

; ------------------------------------------------------------------------------
; Markdown
; ------------------------------------------------------------------------------

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)

(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

; ------------------------------------------------------------------------------
; Python
; ------------------------------------------------------------------------------

(autoload 'python-mode "python-mode"
  "Major mode for editing Python files" t)

(defun python-mode-custom()
  "Custom hook for python-mode"
  (setq indent-tabs-mode nil)
  (local-set-key [backspace] 'py-electric-backspace)
  (setq autopair-handle-action-fns
		(list #'autopair-default-handle-action
			  #'autopair-python-triple-quote-action))
  (setq default-fill-column 80))

(add-hook 'python-mode-hook 'python-mode-custom)

(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(add-to-list 'auto-mode-alist '("boltfile" . python-mode))
(add-to-list 'auto-mode-alist '("Boltfile" . python-mode))
(add-to-list 'auto-mode-alist '("revhook" . python-mode))
(add-to-list 'auto-mode-alist '("SConscript" . python-mode))
(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("wscript" . python-mode))

(add-to-list 'interpreter-mode-alist '("pypy-c" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(add-to-list 'interpreter-mode-alist '("python2.3" . python-mode))
(add-to-list 'interpreter-mode-alist '("python2.4" . python-mode))
(add-to-list 'interpreter-mode-alist '("python2.5" . python-mode))
(add-to-list 'interpreter-mode-alist '("python2.6" . python-mode))
(add-to-list 'interpreter-mode-alist '("python2.7" . python-mode))

(setq py-smart-indentation t)
(setq py-python-command "python")
(setq py-jump-on-exception t)
(setq py-pdbtrack-do-tracking-p t)

; ------------------------------------------------------------------------------
; Cython
; ------------------------------------------------------------------------------

(define-derived-mode cython-mode python-mode "Cython"
  (font-lock-add-keywords
   nil
   `((,(concat "\\<\\(NULL"
	       "\\|c\\(def\\|har\\|typedef\\)"
	       "\\|e\\(num\\|xtern\\)"
	       "\\|float"
	       "\\|in\\(clude\\|t\\)"
	       "\\|object\\|public\\|struct\\|type\\|union\\|void"
	       "\\)\\>")
      1 font-lock-keyword-face t))))

(add-to-list 'auto-mode-alist '("\\.py[xdi]?$" . cython-mode))

; ------------------------------------------------------------------------------
; ReStructuredText
; ------------------------------------------------------------------------------

(setq rst-level-face-base-color "black")

(require 'rst)

;; (autoload 'rst-mode "rst-mode"
;;   "Major mode for editing reStructuredText files" t)

(defun rst-mode-custom()
  "Custom hook for rst-mode"
  (footnote-mode)
  (define-key (current-local-map) (kbd "A-f") 'Footnote-add-footnote)
  (setq default-tab-width 4)
  (set-fill-column 80)
  (setq indent-tabs-mode nil))

(add-hook 'rst-mode-hook 'rst-mode-custom)

(add-to-list 'auto-mode-alist '("\\.notes$" . rst-mode))
(add-to-list 'auto-mode-alist '("\\.rst$" . rst-mode))
(add-to-list 'auto-mode-alist '("\\.txt$" . rst-mode))

(setq rst-preferred-decorations '( (?= over-and-under 0)
								   (?- over-and-under 0)
								   (?= simple 0)
								   (?- simple 0)
								   (?~ simple 0)
								   (?+ simple 0)
								   (?` simple 0)
								   (?# simple 0)
								   (?@ simple 0) ))

; ------------------------------------------------------------------------------
; Ruby
; ------------------------------------------------------------------------------

(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

; ------------------------------------------------------------------------------
; Sass
; ------------------------------------------------------------------------------

(autoload 'sass-mode "sass-mode"
  "Major mode for editing Sass files" t)

(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))

; ------------------------------------------------------------------------------
; XML & HTML
; ------------------------------------------------------------------------------

(autoload 'nxml-mode "nxml-mode"
  "Major mode for editing XML & HTML files" t)

(defun nxml-mode-custom()
  "Custom hook for nxml-mode"
  (define-key (current-local-map) [M-return] 'nxml-complete))

(add-hook 'nxml-mode-hook 'nxml-mode-custom)

(add-to-list 'auto-mode-alist '("\\.html$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.genshi$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.mako$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.rng$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.tpl$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsl$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsd$" . nxml-mode))

(setq nxml-attribute-indent 8)
(setq nxml-child-indent 4)
(setq nxml-sexp-element-flag t)
(setq nxml-slash-auto-complete-flag t)
(setq nxml-bind-meta-tab-to-complete-flag t)

(eval-after-load "rng-loc"
  '(add-to-list
	'rng-schema-locating-files "~/.emacs.d/code/html5-el/schemas.xml"))

; (require 'whattf-dt)

; ------------------------------------------------------------------------------
; YAML
; ------------------------------------------------------------------------------

(autoload 'yaml-mode "yaml-mode"
  "Major mode for editing YAML files" t)

(defun yaml-mode-custom()
  "Custom hook for yaml-mode"
  (define-key yaml-mode-map "\C-m" 'newline-and-indent))

(add-hook 'yaml-mode-hook 'yaml-mode-custom)

(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

; ------------------------------------------------------------------------------
; Appearance
; ------------------------------------------------------------------------------

(load "~/.emacs.d/aaken-dark.el")

(if window-system
    (color-theme-aaken-dark))

; ------------------------------------------------------------------------------
; Key Bindings
; ------------------------------------------------------------------------------

(defun insert-hash-mark () "Insert a hash character" (interactive)
  (insert-char ?# 1))

(defun insert-done-mark () "Insert a tick character" (interactive)
  (insert-char ?✓ 1))

(defun insert-todo-mark () "Insert a todo character" (interactive)
  (insert-char ?✗ 1))

(defun insert-em-dash () "Insert an em dash" (interactive)
  (insert-char ?— 1))

(defun compile-with-make () "Compile the current buffer" (interactive)
  (compile "make")
  (windmove-down))

(defun reopen-killed-buffer () "Re-open the last killed buffer" (interactive)
  (let ((recently-killed-list (copy-sequence recentf-list))
		(buffer-files-list
		 (delq nil (mapcar (lambda (buf)
							 (when (buffer-file-name buf)
							   (expand-file-name (buffer-file-name buf))))
						   (buffer-list)))))
    (mapc
     (lambda (buf-file)
       (setq recently-killed-list
			 (delq buf-file recently-killed-list)))
     buffer-files-list)
    (find-file (car recently-killed-list))))

(defun goto-matching-delimiter () "Go to the matching delimiter" (interactive)
  (cond ((looking-at "[\[\(\{]") (forward-sexp))
        ((looking-back "[\]\)\}]" 1) (backward-sexp))
        ((looking-at "[\]\)\}]") (forward-char) (backward-sexp))
        ((looking-back "[\[\(\{]" 1) (backward-char) (forward-sexp))
        (t nil)))

(defun select-delimited-region () "Select the delimited region" (interactive)
  (set-mark (point))
  (goto-matching-delimiter))

(global-set-key "\M- " 'hippie-expand)
(global-set-key "\M-3" 'insert-hash-mark)
(global-set-key "\M-4" 'insert-done-mark)
(global-set-key "\M-5" 'insert-todo-mark)

(global-set-key "\C-f" 'ido-switch-buffer)
(global-set-key "\C-n" 'other-window)
(global-set-key "\C-o" 'ido-find-file)
(global-set-key "\C-q" 'fill-paragraph)
(global-set-key "\C-z" 'reopen-killed-buffer)
(global-set-key "\C-]" 'select-delimited-region)

(global-set-key (kbd "<C-next>") 'next-error)
(global-set-key (kbd "<C-prev>") 'previous-error)
(global-set-key (kbd "<C-left>") 'backward-sexp)
(global-set-key (kbd "<C-right>") 'forward-sexp)

(define-key global-map (kbd "C-'") 'iedit-mode)
(define-key iedit-mode-map (kbd "C-'") 'iedit-mode)
(define-key isearch-mode-map (kbd "C-'") 'iedit-mode)
(global-set-key (kbd "^-") 'rst-repeat-last-character)

(global-set-key [next] 'pager-page-down)
(global-set-key [prior] 'pager-page-up)
(global-set-key [(meta up)] 'pager-row-up)
(global-set-key [(meta down)] 'pager-row-down)
(global-set-key [(meta left)] 'backward-word)
(global-set-key [(meta right)] 'forward-word)

(global-set-key (kbd "<C-tab>") 'bs-cycle-next)
(global-set-key (kbd "<C-S-tab>") 'bs-cycle-previous)

(global-set-key (kbd "^C c") 'comment-region)
(global-set-key (kbd "^C i") 'ucs-insert)
(global-set-key (kbd "^C q") 'quoted-insert)
(global-set-key (kbd "^C u") 'uncomment-region)

(global-set-key (kbd "^X <up>") 'windmove-up)
(global-set-key (kbd "^X <down>") 'windmove-down)
(global-set-key (kbd "^X <left>") 'windmove-left)
(global-set-key (kbd "^X <right>") 'windmove-right)

(global-set-key (kbd "^X <C-up>") 'windmove-up)
(global-set-key (kbd "^X <C-down>") 'windmove-down)
(global-set-key (kbd "^X <C-left>") 'windmove-left)
(global-set-key (kbd "^X <C-right>") 'windmove-right)

(global-set-key [delete] 'delete-char)
(define-key global-map [backspace] 'delete-backward-char)

(global-set-key [f3] 'buffer-menu)
(global-set-key [f6] 'speedbar-get-focus)
(global-set-key [f9] 'make-frame-on-display)

(define-key ac-mode-map [M-return] 'auto-complete)
(define-key ac-mode-map [M-tab] 'auto-complete)
(define-key global-map "\M-_" 'insert-em-dash)

;; (define-key global-map (kbd "<S-up>") 'previous-line-mark)
;; (define-key global-map (kbd "<S-down>") 'next-line-mark)
;; (define-key global-map (kbd "<S-left>") 'backward-char-mark)
;; (define-key global-map (kbd "<S-right>") 'forward-char-mark)

(define-key osx-key-mode-map (kbd "A-/") 'bookmark-bmenu-list)
(define-key osx-key-mode-map (kbd "A-b") 'bookmark-set)
(define-key osx-key-mode-map (kbd "A-d") 'vc-diff)
(define-key osx-key-mode-map (kbd "A-e") 'shell-command)
(define-key osx-key-mode-map (kbd "A-f") 'rgrep)
(define-key osx-key-mode-map (kbd "A-g") 'magit-status)
(define-key osx-key-mode-map (kbd "A-h") 'enable-hide-show)
(define-key osx-key-mode-map (kbd "A-i") 'yas/insert-snippet)
(define-key osx-key-mode-map (kbd "A-k") 'ido-kill-buffer)
(define-key osx-key-mode-map (kbd "A-m") 'compile-with-make)
(define-key osx-key-mode-map (kbd "A-r") 'recentf-open-files)
(define-key osx-key-mode-map (kbd "A-p")
  'flyspell-check-previous-highlighted-word)

(define-key osx-key-mode-map (kbd "A-u") 'gist-buffer)
(define-key osx-key-mode-map (kbd "A-;") 'comment-or-uncomment-region-or-line)

; ------------------------------------------------------------------------------
; Tips
; ------------------------------------------------------------------------------

; (pc-selection-mode)
; (smart-frame-positioning-mode nil)
; (setq show-trailing-whitespace t)

; ^C ^H -- list of keybindings starting with C-c
; ^H a -- search commands
; ^H k -- description of a keybinding
; ^H f -- description of a function
; ^H m -- to display the current major/minor modes
; ^H v -- description of a variable

; Use ^; to toggle the option key as meta
; Use ^/ to undo, it's easier than ^_

; ^X n n -- to narrow to region
; ^X n w -- to widen back to everything

; Ido mode:
;
; C-s (next)
; C-r (previous) 
; C-f (fallback to find-file)
; C-b (fallback to switch-to-buffer)
; C-d (fallback to dired)
; C-space (complete further on filter input)
; M-p (previous directory in history)
; M-n (next directory in history)
; M-s (search for a file)

; Type B in Dired to byte-compile an elisp file
; To set-fill-column, use M-<number> C-x f

; Macros:
;  start: C-x (
;    end: C-x )
;   exec: C-x e
; insert: M-x insert-kbd-macro
;  apply: M-x apply-macro-to-region-lines
;   name: M-x name-last-kbd-macro

; To repeat: M-<number> ...
; M-m -- jump to the first non-whitespace character on current line

; ^X ^E -- eval-last-sexp
; ^X ^O -- delete-blank-lines

; M-x diff-buffer-with-file
; M-x vc-diff
; M-x ediff-revision
; Type M-- before M-u, M-l, etc. to apply to previous word

; Colour nested delimiters according to their depth:
; http://www.emacswiki.org/emacs/rainbow-delimiters.el

; (load "~/.emacs.d/custom.el")

; (set-frame-parameter nil 'alpha 73)
