;;; undo-tree-mode-setup --- undo-tree configuration:
;;; Commentary:
;;; Code:

;; * START undo-tree melpa plugin ( undo-redo ) setup *
(require 'undo-tree)
(global-undo-tree-mode t)

;; set hook that load undo-tree history files, when switching buffers
(if use_undo_tree_history_files ;; "use_undo_tree_history_files" in index.el
    (progn
      (remove-hook 'find-file-hook 'undo-tree-load-history-hook) ;; disable default
      (setq undo-tree-auto-save-history t) ;; auto save history
      (setq undo-tree-history-directory-alist `(("." . ,undo_redo_dir))) ;; set history directory
      (defadvice undo-tree-make-history-save-file-name ;; enable compress history
          (after undo-tree activate)
        (setq ad-return-value (concat ad-return-value ".gz")))

      (setq loaded_undo_tree_history_files nil) ;; list of loaded history files
      (setq last_buffer_from_previous_session (buffer-name (car (buffer-list)))) ;; restore last used buffer, from previous session, from buffer list
      (setq undo_tree_history_initialized nil) ;; is undo-tree initialized
      (setq allow_execute_load_undo_tree_history_file t) ;; prevent execute while lazy loading (allow execute on first time when emacs starting, so set-> "t")

      (defun set_allow_execute_load_undo_tree_history_file (orig-fun &rest args) ;; prevent execute while lazy load file
        (setq allow_execute_load_undo_tree_history_file nil) ;; start prevent
        (apply orig-fun args)
        (setq allow_execute_load_undo_tree_history_file t) ;; stop prevent
        )
      (advice-add 'desktop-lazy-create-buffer :around #'set_allow_execute_load_undo_tree_history_file)

      (add-hook 'window-configuration-change-hook 'load_undo_tree_history_file ) ;; hook when current-buffer will be changed

      (defun load_undo_tree_history_file()
        (progn
          (if (or undo_tree_history_initialized (eq (buffer-name (current-buffer)) last_buffer_from_previous_session)) ;; on first loading, when emacs not loaded completelly, and it is last used buffer, restore history file (in next times, in other cases, parameter "undo_tree_history_initialized" make execute code allways)
              (progn
                (if (and
                     (not (member (buffer-file-name (current-buffer)) loaded_undo_tree_history_files)) ;; if history file still not loaded and ... ( see below )
                     (eq (type-of (buffer-file-name (current-buffer))) 'string) ;; if file name string
                     (buffer-file-name (current-buffer)) ;; if current buffer has file, load this undo-tree history file.
                     allow_execute_load_undo_tree_history_file
                     )
                    (progn
                      (if (undo-tree-load-history nil t) ;; load "current-buffer" history file, with disabled error message on file not found (   t) - at end
                          (add-to-list 'loaded_undo_tree_history_files (buffer-file-name (current-buffer))) ;; save to list loaded history file, for prevent load again
                        )
                      )
                  )
                (setq undo_tree_history_initialized t) ;; set undo-tree was initialized
                )
            )
          )
        )
      )
  )
;; END
;; * END *

;; * Disable error on free variables *
;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:

;;; undo-tree-mode-setup.el ends here
