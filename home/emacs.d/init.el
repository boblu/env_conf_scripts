;; ==========================================
;; Basic configurations of emacs itself
;; ==========================================
;; disable C-z 'cause it is used as escape in screen command
(global-unset-key (kbd "C-z"))

;; show current column number on modeline
(column-number-mode 1)

;; show line number at left margin
(global-linum-mode 1)
;; this will set a space between line number and content when using terminal
(if (not window-system)
    (setq linum-format "%d ")
)

;; show return code
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; does not show start up message
(setq inhibit-startup-message t)

;; display time
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-interval 10)

;; enable to view image file
(auto-image-file-mode)

;; using 'y/n' instead of 'yes/no'
(fset 'yes-or-no-p 'y-or-n-p)	

;; end file with blank line
(setq require-final-newline t)

;; display the upper directory's name when open files with same name in different directories
(when (locate-library "uniquify")
  (require 'uniquify)
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

;; make *scratch* buffer blank after start up    
(setq initial-scratch-message nil)

;; highlighting pairing bracket
(show-paren-mode t) 
(setq show-paren-style 'mixed)              ;color both inside and parenthesis 

;; use bash
(setq shell-file-name "bash")
;; hide password in shell-mode
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)


;; ==========================================
;; Extension settings
;; ==========================================
;; use ido
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

;; save all your opened files
;; usage:      M-x desktop-save    to save desktop
;;             M-x desktop-clear   to clear desktop
(load "desktop")
(desktop-load-default)
(desktop-read)


;; ==========================================
;; Customize key bindings
;; ==========================================
;; change to view mode
(global-set-key "\C-x\C-v" 'view-mode)

;; comment region
(global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)
;; comment current line
(defadvice comment-or-uncomment-region (before slick-comment activate compile)
  "When called interactively with no active region, comment a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
	   (line-beginning-position 2)))))

;; select current word
;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.
(defun semnav-up (arg)
  (interactive "p")
  (when (nth 3 (syntax-ppss))
    (if (> arg 0)
        (progn
          (skip-syntax-forward "^\"")
          (goto-char (1+ (point)))
          (decf arg))
      (skip-syntax-backward "^\"")
      (goto-char (1- (point)))
      (incf arg)))
  (up-list arg))

;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.
(defun extend-selection (arg &optional incremental)
  "Select the current word.
Subsequent calls expands the selection to larger semantic unit."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     (or (and transient-mark-mode mark-active)
                         (eq last-command this-command))))
  (if incremental
      (progn
        (semnav-up (- arg))
        (forward-sexp)
        (mark-sexp -1))
    (if (> arg 1)
        (extend-selection (1- arg) t)
      (if (looking-at "\\=\\(\\s_\\|\\sw\\)*\\_>")
          (goto-char (match-end 0))
        (unless (memq (char-before) '(?\) ?\"))
          (forward-sexp)))
      (mark-sexp -1))))

(global-set-key (kbd "M-8") 'extend-selection)

(defun select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters are paired characters: ()[]<>«»“”‘’「」, including \"\"."
  (interactive)
  (let (b1 b2)
    (skip-chars-backward "^<>(“{[「«\"‘")
    (setq b1 (point))
    (skip-chars-forward "^<>)”}]」»\"’")
    (setq b2 (point))
    (set-mark b1)
    )
  )

(global-set-key (kbd "M-*") 'select-text-in-quote)

;; ==========================================
;; Tips on emacs usage
;; ==========================================
;; indent region
;; C-M-\

;; input repeated character
;; C-u number
