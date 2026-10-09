;; NOTE: Almost all functions and configs are inspired or copy-pasted from the internet. They are not mine.
;; I've tried to put all the links which are refrenced but I forgot some of them. Sorry.

;------------- UI -------------
;; Don't show splash screen
(setq inhibit-startup-screen t)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(set-fringe-mode 10)        ; Give some breathing room

;; Display line numbers
(column-number-mode)
(global-display-line-numbers-mode 1)

;; Set fullscrenn when stratup
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Flash when the bell rings
(setq visible-bell t)

;; Theme
(setf custom-safe-themes t)
(load-theme 'almost-mono-black t nil)

;; Font
(set-frame-font "Iosevka Fixed Bold 12" nil t)

;; replace y-n instead of yes-no in command mode
(defalias 'yes-or-no-p 'y-or-n-p)

(ido-mode 1)

;; Backups at .saves folder in the current folder
(setq backup-by-copying t      ; don't clobber symlinks
      backup-directory-alist
      '(("." . "~/.saves"))    ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups

;; Auto_save
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      create-lockfiles nil)

;; utf-8
(prefer-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-auto-unix)

;; Large file warning
(setq large-file-warning-threshold (* 15 1024 1024))

;; Whitespace mode
(require 'whitespace)
(global-whitespace-mode t)
(setq whitespace-line-column 120
      whitespace-style '(face trailing tabs spaces lines newline missing-newline-at-eof
                         empty indentation space-after-tab space-before-tab space-mark tab-mark))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-big-indent ((t nil)))
 '(whitespace-empty ((t (:extend t))))
 '(whitespace-hspace ((t (:foreground "#282828"))))
 '(whitespace-indentation ((t (:foreground "#282828"))))
 '(whitespace-line ((t (:background "#FF4f58" :foreground "white"))))
 '(whitespace-newline ((t nil)))
 '(whitespace-space ((t (:foreground "#282828"))))
 '(whitespace-space-after-tab ((t (:foreground "#282828"))))
 '(whitespace-space-before-tab ((t (:foreground "#282828")))))
(setq-default indent-tabs-mode nil)

(delete-selection-mode 1)      ;; when writing over selection, to replace

;; Fix bug ownership server in windows
;; from https://stackoverflow.com/a/1313577
(require 'server)
(and (eq window-system 'w32)
     (>= emacs-major-version 23)
     (defun server-ensure-safe-dir (dir) "Noop" t))


(display-battery-mode +1)
(setq display-time-day-and-date t)
(display-time)

(setq user-full-name    "Mahdi"
      user-mail-address "esmokes17@gmail.com")

(defun display-startup-echo-area-message ()
  "The message that is shown after ‘user-init-file’ is loaded."
  (message
      (concat "Welcome "      user-full-name
              "! Emacs "      emacs-version
              "/"             (system-name)
              "; Time "       (emacs-init-time))))

;------------- Package -------------
;; init package manager
(require 'package)
(setq package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; packages installation
(use-package yasnippet-snippets)

(use-package magit
  :bind* (("C-c C-g" . magit-status)
          ("M-m g b" . magit-blame)))

(use-package company
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode)
  :custom
  (company-global-modes '(not shell-mode eaf-mode))
  :config
  (add-to-list 'company-backends 'company-c-headers))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom (
           (dired-listing-switches "-agho --group-directories-first")
           ((dired-dwim-target t)))
  )

(use-package async
  :commands (async-start)
  :config (async-bytecomp-package-mode 1))
(autoload 'dired-async-mode "dired-async.el" nil t)
(dired-async-mode 1)

(eval-after-load "dired" '(progn
  (add-hook 'dired-mode-hook 'auto-revert-mode)))

(use-package yasnippet
  :config
    (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
    (yas-global-mode 1))

(use-package multiple-cursors
  :bind (("C-M-SPC" . set-rectangular-region-anchor)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C->" . mc/mark-all-like-this)
         ("C-c C-SPC" . mc/edit-lines)
         ))

(use-package ansi-color
    :hook (compilation-filter . ansi-color-compilation-filter))

; Python
(use-package python-mode
  :after flycheck
  :mode "\\.py\\'"
  :custom
  (python-indent-offset 4)
  (flycheck-python-pycompile-executable "python3")
  (python-shell-interpreter "python3"))

; C/C++
(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
(setq-default c-basic-offset 4)
(defconst my-cc-style
  '("cc-mode"
    (c-offsets-alist . ((innamespace . [0])))))
(c-add-style "my-cc-mode" my-cc-style)
(add-hook 'c++-mode-hook '(lambda ()
                            (c-set-style "my-cc-mode")
                            (gtags-mode 1)
                            ))
;; C++ 11 new keywords
(font-lock-add-keywords 'c++-mode
                        '(("\\<\\(thread_local\\)\\>" . font-lock-warning-face)
                          ("\\<\\(constexpr\\)\\>" . font-lock-keyword-face)
                          ))
;; Compile the current file with g++ into <file>.out
(defun compile-cpp (std &optional flags)
  (compile (format "g++ -Wall -g -std=%s %s%s -o %s.out"
                   std (or flags "") (buffer-file-name)
                   (file-name-sans-extension (buffer-file-name)))))
(defun compile-cpp-simple () (interactive) (compile-cpp "c++11"))
(defun compile-cpp-thread () (interactive) (compile-cpp "c++11" "-lpthread "))
(defun compile-cpp-17 () (interactive) (compile-cpp "c++17"))

;; Haskell
(use-package haskell-mode)

;; (use-package cmake-mode
;;  :ensure t)

;------------- Functions -------------
;; from https://emacs.stackexchange.com/a/29877
(defun sizeof-region ()
  (interactive)
  (let ((strg  (if (use-region-p)
                   (buffer-substring-no-properties (region-beginning) (region-end))
                 "")))
    (message "Region has %d bytes" (string-bytes strg))))

;; from https://sriramkswamy.github.io/dotemacs/
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))

;; TODO: load for win
(if (eq system-type 'windows-nt)
    (defun run-bash ()
      (interactive)
      (let ((shell-file-name "C:\\Program Files\\Git\\bin\\bash.exe"))
        (shell "*bash*")))
  )

;; from https://sriramkswamy.github.io/dotemacs/
(defun split-below-and-move ()
  (interactive)
  (split-window-below)
  (other-window 1))
(defun split-right-and-move ()
  (interactive)
  (split-window-right)
  (other-window 1))


(defun browse-current-file ()
  "Open the current file as a URL using `browse-url'."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if (and (fboundp 'tramp-tramp-file-p)
             (tramp-tramp-file-p file-name))
        (error "Cannot open tramp file")
      (browse-url (concat "file://" file-name)))))


(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun join-line ()
  "Join the current line with the next line"
  (interactive)
  (next-line)
  (delete-indentation))

;; from https://github.com/cjohansen/.emacs.d/
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun duplicate-region (&optional num start end)
  "Duplicates the region bounded by START and END NUM times.
If no START and END is provided, the current region-beginning and
region-end is used."
  (interactive "p")
  (save-excursion
    (let* ((start (or start (region-beginning)))
           (end (or end (region-end)))
           (region (buffer-substring start end)))
      (goto-char end)
      (dotimes (i num)
        (insert region)))))

(defun duplicate-current-line (&optional num)
  "Duplicate the current line NUM times."
  (interactive "p")
  (save-excursion
    (when (eq (line-end-position) (point-max))
      (goto-char (point-max))
      (newline)
      (forward-char -1))
    (duplicate-region num (line-beginning-position) (1+ (line-end-position)))))

(defun duplicate-line-or-region (&optional num)
  "Duplicate the current line or region if active"
  (interactive "p")
  (if (region-active-p)
      (let ((beg (region-beginning))
            (end (region-end)))
        (duplicate-region num beg end)))
  (duplicate-current-line num))

;; from https://stackoverflow.com/a/2423919
(defun move-text-internal (arg)
   (cond
    ((and mark-active transient-mark-mode)
     (if (> (point) (mark))
            (exchange-point-and-mark))
     (let ((column (current-column))
              (text (delete-and-extract-region (point) (mark))))
       (forward-line arg)
       (move-to-column column t)
       (set-mark (point))
       (insert text)
       (exchange-point-and-mark)
       (setq deactivate-mark nil)))
    (t
     (beginning-of-line)
     (when (or (> arg 0) (not (bobp)))
       (forward-line)
       (when (or (< arg 0) (not (eobp)))
            (transpose-lines arg))
       (forward-line -1)))))
(defun move-text-down (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines down."
   (interactive "*p")
   (move-text-internal arg))
(defun move-text-up (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines up."
   (interactive "*p")
   (move-text-internal (- arg)))

(defun indent-region-custom(numSpaces)
    (progn
        ; default to start and end of current line
        (setq regionStart (line-beginning-position))
        (setq regionEnd (line-end-position))

        ; if there's a selection, use that instead of the current line
        (when (use-region-p)
            (setq regionStart (region-beginning))
            (setq regionEnd (region-end))
        )

        (save-excursion ; restore the position afterwards
            (goto-char regionStart) ; go to the start of region
            (setq start (line-beginning-position)) ; save the start of the line
            (goto-char regionEnd) ; go to the end of region
            (setq end (line-end-position)) ; save the end of the line

            (indent-rigidly start end numSpaces) ; indent between start and end
            (setq deactivate-mark nil) ; restore the selected region
        )
    )
)
(defun untab-region (N)
    (interactive "p")
    (indent-region-custom -4)
)
(defun tab-region (N)
    (interactive "p")
    (if (active-minibuffer-window)
        (minibuffer-complete)    ; tab is pressed in minibuffer window -> do completion
    ; else
    (if (string= (buffer-name) "*shell*")
        (comint-dynamic-complete) ; in a shell, use tab completion
    ; else
    (if (use-region-p)    ; tab is pressed is any other buffer -> execute with space insertion
        (indent-region-custom 4) ; region was selected, call indent-region-custom
        (insert "    ") ; else insert four spaces as expected
    )))
)

(defun dired-duplicate-this-file ()
  "Duplicate file on this line."
  (interactive)
  (let* ((this  (dired-get-filename t))
         (ctr   1)
         (new   (format "%s[%d]" this ctr)))
    (while (file-exists-p new)
      (setq ctr  (1+ ctr)
            new  (format "%s[%d]" this ctr)))
     (dired-copy-file this new nil))
  (revert-buffer))
(define-key dired-mode-map (kbd "c") 'dired-duplicate-this-file)

;; TODO: delete
(defun save-buffer-without-tabs ()
  (interactive)
  (untabify (point-min) (point-max))
  (save-buffer))

;; https://rb.gy/xp4hk
(defun insert-date ()
  "Insert today's date at point"
  (interactive "*")
  (insert (format-time-string "%F")))

;; https://stackoverflow.com/a/14189981
(defun newline-without-break-of-line ()
  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent)))

;; https://stackoverflow.com/a/22480022
(defun copy-line ()
  (interactive)
  (kill-ring-save (line-beginning-position) (line-end-position))
  (message "line copied"))


;------------- Bind Keys -------------
(bind-keys*
  ("C-x 3"      . split-below-and-move)
  ("C-x 2"      . split-right-and-move)
  ("C-;"        . comment-or-uncomment-region-or-line)
  ("C-c C-r"    . rename-current-buffer-file)
  ("M-S-<down>" . duplicate-line-or-region)
  ("M-S-<up>"   . duplicate-line-or-region)
  ("C-d"        . join-line)
  ("M-<up>"     . move-text-up)
  ("M-<down>"   . move-text-down)
  ("C-\+"       . text-scale-increase)
  ("C-\-"       . text-scale-decrease)
  ("\C-x\C-s"   . save-buffer-without-tabs)
  ("C-M-_"      . default-text-scale-decrease)
  ("C-M-+"      . default-text-scale-increase)
  ("M-\]"       . tab-region)
  ("M-\["       . untab-region)
  ("M-m g B"    . browse-current-file)
  ("C-c s"      . isearch-forward-symbol-at-point)
  ("C-c d"      . insert-date)
  ("C-c b"      . browse-url)
  ("C-c c"      . copy-line)
  ("C-<return>"  . newline-without-break-of-line))

;; Open .emacs file quickly
;; TODO: add to list of bind keys
(global-set-key (kbd "<f6>") (lambda () (interactive)
  (find-file "~/.emacs")
  (message "Opened:  %s" (buffer-name))))


;; Keep Customize output out of this file.
(setq custom-file (expand-file-name "~/.emacs-custom.el"))
(load custom-file 'noerror)
(setq warning-suppress-log-types '((use-package)))
