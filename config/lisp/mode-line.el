;;; mode-line.el --- mode-line configuration
;;; Commentary:
;;; Code:

;; mode line configuration
(setq display-time-24hr-format t)
(display-time-mode t)
(line-number-mode t)
(size-indication-mode t)
(column-number-mode t)
(setq auto-revert-check-vc-info t)

(defface buffer_path
  '((t :foreground "#FFFFFF" :weight normal))
  "Face for highlight current buffer path.")
(defface buffer_path_dir
  '((t :foreground "#B8F2FE" :weight normal))
  "Face for highlight directory of current buffer.")
(defface buffer_path_file
  '((t :foreground "#EDC9AF" :weight normal))
  "Face for highlight file of current buffer.")
(defface mode_line_position
  '((t :foreground "#FFFFFF" :weight normal))
  "Face for highlight cursor position.")
(defface mode_line_buffer_size
  '((t :foreground "#FFFFFF" :weight normal))
  "Face for highlight buffer size.")
(defface mode_line_modified
  '((t :foreground "#FFFFFF" :weight normal))
  "Face for highlight buffer modified.")

(defun buffer_path(&optional path_limit part_length)
  "Get active buffer path, with limit path length"
  (let ((path))
    (setq default_path_limit 50)
    (setq default_part_length 20)
    (setq curr_path (or buffer-file-name (directory-file-name default-directory)))
    (or path_limit (setq path_limit default_path_limit))
    (cond ((not part_length)
           (setq path curr_path))
          (part_length
           (setq path (format
                       "%s%s%s"
                       (propertize (mapconcat
                         'identity
                         (let ((result ()))
                           (dolist (element (split-string curr_path "\\/"))
                             (if (< part_length (length element))
                                 (push (substring element 0 part_length) result)
                               (push element result)))
                           (nreverse (nthcdr 2 result)))
                         "/") 'face 'buffer_path)
                       (propertize (concat
                                    "/"
                                    (file-name-nondirectory (directory-file-name (file-name-directory curr_path))))
                                   'face 'buffer_path_dir) ;; file or dir parent name
                       (propertize (concat
                                    "/"
                                    (file-name-nondirectory curr_path))
                                   'face 'buffer_path_file))))) ;; file or dir name
    (if (> (length path) path_limit)
        (progn
          (if (not part_length) (setq part_length (1+ default_part_length)))
          (setq part_length (1- part_length))
          (if (>= part_length 0)
              (setq path (buffer_path path_limit part_length)))
            (replace-regexp-in-string "\\/\\{2,\\}" "" path))
      path)))

(defun mode-line-fill (face reserve)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (unless reserve
    (setq reserve 20))
  (when (and window-system (eq 'right (get-scroll-bar-mode)))
    (setq reserve (- reserve 3)))
  (propertize " "
              'display `((space :align-to (- (+ right right-fringe right-margin) ,reserve)))
              'face face))

(setq-default mode-line-format
              (list
               "%e"
               'mode-line-front-space
               '(:eval (propertize "%+" 'face 'mode_line_modified)) ;; readonly, modified
               " "
               'mode-line-mule-info
               " "
               '(:eval (propertize "%l:%C %P" 'face 'mode_line_position)) ;; line, column, position at buffer in %
               " "
               'mode-line-client
               'mode-line-remote
               'mode-line-frame-identification
               '(:eval (buffer_path))
               " "
               '(:eval (propertize "%I" 'face 'mode_line_buffer_size)) ;; file size
               " "
               '(vc-mode vc-mode)
               " "
               'mode-line-modes
               (mode-line-fill 'mode-line 6) ;; fill line with spaces
               '(:eval (format-time-string "%H.%M"))
               'mode-line-end-spaces
               ))

;;; mode-line.el ends here
