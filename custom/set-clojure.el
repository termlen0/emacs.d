;;; set-clojure.el --- clojure module settings file
;;
;; Filename: set-clojure.el
;;
;; Copyright (c) 2014 Ed Maphis
;;
;; Author: Ed Maphis
;;
;; Created: Sat Aug 18 9:41:00 2014 (-0400)
;;
;; URL: https://github.com/emaphis/emacs.d
;;
;; Keywords: emacs settings clojure
;; Compatibility: emacs 24.4
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;  Emacs modules and settings for clojure development.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; License:
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;;; customizations are mostly from: https://github.com/clojure-emacs/cider

;;; turn on eldoc mode
(add-hook 'cider-repl-mode-hook 'cider-turn-on-eldoc-mode)
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)


;;; hide special buffers: *nrepl-connection* and *nrepl-server*
(setq nrepl-hide-special-buffers t)

;;; 'TAB' key behavior
; (setq cider-repl-tab-command 'indent-for-tab-command)

;;;  prefer local resources to remote (tramp) ones when both are available:
; (setq cider-prefer-local-resources t)

;;; prevent the auto-display of the REPL buffer in a separate window
;;; after connection is established:
; (setq cider-repl-pop-to-buffer-on-connect nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; error handling
;;;
;;; Configure whether the error buffer with stacktraces should be
;;; automatically shown on error:
;;; Use 'cider-visit-error-buffer' to visit this buffer
;(setq cider-show-error-buffer nil) ;; Don't show on error

;;; Independently of the value of 'cider-show-error-buffer', the error buffer
;;; is always generated in the background. Use 'cider-visit-error-buffer' to
;;; visit this buffer.
;(setq cider-show-error-buffer 'except-in-repl) ; or
;(setq cider-show-error-buffer 'only-in-repl)

;;;  To disable auto-selection of the error buffer when it's displayed:
(setq cider-auto-select-error-buffer nil)

;;; Using the wrap-stacktrace middleware from cider-nrepl, filter stack-trace
;;; output. Options: java, clj, repl, tooling, dup, and nil.
(setq cider-stacktrace-default-filters '(tooling dup))

;; error message wrapping
(setq cider-stacktrace-fill-column 80)


;;; REPL buffer name separator.
(setq nrepl-buffer-name-separator "-")
;;; show the port in the buffer name
(setq nrepl-buffer-name-show-port t)


;;; Make C-c C-z switch to the CIDER REPL buffer in the current window:
(setq cider-repl-display-in-current-window t)

;;;  Prevent C-c C-k from prompting to save the file corresponding to
;;; the buffer being loaded, if it's modified:
(setq cider-prompt-save-file-on-load nil)

;;; Change the result prefix for REPL evaluation (by default there's no prefix):
(setq cider-repl-result-prefix " => ")

;;; Change the result prefix for interactive evaluation (by default it's =>):
;;; To remove the prefix altogether just set it to an empty string("").
(setq cider-interactive-eval-result-prefix " => ")

;;;  font-lock the repl  as in clojure-mode, instead of 'cider-repl-input-face'
(setq cider-repl-use-clojure-font-lock t)

;;; setting cider known endpoints
;; (setq cider-known-endpoints '(("host-a" "10.10.10.1" "7888") ("host-b" "7888")))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; REPL history
;;;
;;; To make the REPL history wrap around when its end is reached:
(setq cider-repl-wrap-history t)

;;; To adjust the maximum number of items kept in the REPL history:
(setq cider-repl-history-size 1000) ; the default is 500

;;; To store the REPL history in a file:
(setq cider-repl-history-file "~/.emacs.d/auto-save-list/cider-history")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Integration with other modes
;;;

;;; idle-highlight
(add-hook 'clojure-mode-hook (lambda () (idle-highlight-mode t)))

;;; java style camelCase
(add-hook 'clojure-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'subword-mode)

;;; 'smartparens'
(add-hook 'clojure-mode-hook 'smartparens-strict-mode)
(add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)

;;; rainbow-delimiters
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

;;; A little more syntax highlighting
(require 'clojure-mode-extra-font-locking)

;;; A function for creating midje facts from cider repl output:
;;  brittle: it requires that the cider-repl-result-prefix be set to "=>"
;;           and that the clojure buffer is before the repl in window order.
(defun cem-extract-midje-fact ()
  "Extract the repl output  and generate a midje fact."
  (interactive)
  (let (pt1 pt1 my-str)
    (setq pt1 (point))
    (search-forward "=>")
    (end-of-line)
    (setq pt2 (point))
    (setq my-str (buffer-substring pt1 pt2))
    (other-window -1)
    (insert (concat  "(fact "  my-str ")"))
    (newline)
    (previous-line)
    (tab-indent-or-complete)
    (next-line)
    (move-beginning-of-line 1)
    (tab-indent-or-complete)
    (other-window +1)
    (next-line)))

(add-hook 'cider-repl-mode-hook
          (lambda ()
            (define-key cider-repl-mode-map
              (kbd "C-c a") 'cem-extract-midje-fact)))


(message "end set-clojure.el")
(provide 'set-clojure)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; set-clojure.el ends here