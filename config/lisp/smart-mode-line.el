;;; smart-mode-line.el --- smart-mode-line configuration
;;; Commentary:
;;; Code:

;; mode line configuration
(setq display-time-24hr-format t)
(display-time-mode t)
(line-number-mode t)
(size-indication-mode t)
(column-number-mode t)

;; smart-mode-line configuration
(setq sml/no-confirm-load-theme t) ;; do not ask load theme at startup
(setq sml/override-theme nil)
(setq sml/theme 'dark)
(sml/setup)
(set-face-attribute 'sml/line-number nil :foreground "white" :weight 'bold)
(set-face-attribute 'sml/col-number nil :foreground "white" :weight 'bold)

;;; smart-mode-line.el ends here