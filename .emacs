;;(require 'column-marker)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; spaces instead of tabs.
;; this can break Makefile(s); be aware!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-default indent-tabs-mode nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SQL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'sql)

(eval-after-load "sql"
  '(load-library "~/Library/GNUEmacs/packages/sql-indent"))

;; for non-standard PostgreSQL ports.
(add-to-list 'sql-postgres-login-params '(port :default 5432))

;; makes emacs recognize the .psql extension i frequently use.
(add-to-list 'auto-mode-alist
             '("\\.psql$" . (lambda ()
                              (sql-mode)
                              (sql-highlight-postgres-keywords))))

;; when toggling-off truncate mode (via toggle-truncate-lines), which is sometimes useful when looking at SQL results, horizonal recentering is useful.
(defun my-horizontal-recenter ()
  "make the point horizontally centered in the window"
  (interactive)
  (let ((mid (/ (window-width) 2))
	(line-len (save-excursion (end-of-line) (current-column)))
	(cur (current-column)))
    (if (< mid cur)
	(set-window-hscroll (select-window)
			    (- cur mid)))))
(global-set-key (kbd "C-S-l") 'my-horizontal-recenter)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ESS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; for site-wide installations.
;(require 'ess-site)

;; for local (user-based home directory) installations.
(add-to-list 'load-path "~/Library/GNUEmacs/packages/ess/lisp/")
(load "ess-site")

;; turns off the annoying feature of turning underscores to '<-' operators.
;; if this feature is not turned off, two underscores in a row are converted to a single underscore.
;; this feature is practically a bug, ATMO.
(ess-toggle-underscore nil)

;; adds the 'C-c w' resize command to match column output to emacs window buffer size.
(defun my-ess-post-run-hook ()
  (ess-execute-screen-options)
  (local-set-key "\C-cw" 'ess-execute-screen-options))
(add-hook 'ess-post-run-hook 'my-ess-post-run-hook)
(put 'scroll-left 'disabled nil)

;; treats open/close-parens with lists like open/close-braces and aligns the close-parens to the start of the expression.
(setq ess-close-paren-offset '(0))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; window management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; WINNER WINNER CHICKEN DINNER! (C-c <- and C-c -> moves between frame 'states')
(winner-mode)

;; enables WindMove, which is controlled with [Shift]-[arrow] to jump between windows within a frame.
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(defun set-window-width (n)
  "Set the selected window's width."
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TERM management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; i run emacs often inside GNU screen, and my .screenrc file declares my TERM as "screen-256color".
(defun terminal-init-screen ()
  "Terminal initialization function for screen-256color."
  (load "term/xterm")
  (xterm-register-default-colors)
  (tty-set-up-initial-frame-faces))

;; kludge to deal with Terminal.app using xterm-256color while interacting with programs running under screen-256color.
;; Terminal.app's key bindings found under Terminal -> Preferences -> Settings -> Keyboard... they're user-mappable, but let's just stick with the defaults here.
(define-key input-decode-map "\e[1;2D" [S-left])
(define-key input-decode-map "\e[1;2C" [S-right])
(define-key input-decode-map "\e[1;2B" [S-down])
(define-key input-decode-map "\e[1;2A" [S-up])
