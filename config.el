;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-


;;; >>> BASIC >>>
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;; <<< END <<<


;;; >>> FONT >>>
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Sarasa Mono SC" :size 18)
      doom-serif-font doom-font
      doom-symbol-font (font-spec :family "Sarasa Mono SC")
      doom-variable-pitch-font (font-spec :family "Sarasa Mono SC"))
;;; <<< END <<<


;;; >>> THEME >>>
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-bluloco-dark)
;;; <<< END <<<


;;; >>> Line Numbers >>>
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
;;; <<< END <<<


;;; >>> ORG >>>
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(after! org
  (setq org-startup-folded t)
  (setq org-log-done 'time))
(after! org
  (setq org-latex-packages-alist
    '(("fontset=SimSun,UTF8" "ctex" t)
      ("" "amsmath" t)))
  (setq org-export-with-smart-quotes t)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.2))
  (setq org-preview-latex-default-process 'dvisvgm) ;; dvisvgm
  (setq org-startup-with-latex-preview t)
  (setq org-preview-latex-process-alist
        '((dvisvgm :programs
                ("xelatex" "dvisvgm")
                :description "xdv > svg" :message "you need to install the programs: xelatex and dvisvgm." :use-xcolor t :image-input-type "xdv" :image-output-type "svg" :image-size-adjust
                (1.7 . 1.5)
                :latex-compiler
                ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
                :image-converter
                ("dvisvgm %f -n -b min -c %S -o %O"))
        (imagemagick :programs
                ("xelatex" "convert")
                :description "pdf > png" :message "you need to install the programs: xelatex and imagemagick." :use-xcolor t :image-input-type "pdf" :image-output-type "png" :image-size-adjust
                (1.0 . 1.0)
                :latex-compiler
                ("xelatex -interaction nonstopmode -output-directory %o %f")
                :image-converter
                ("convert -density %D -trim -antialias %f -quality 100 %O")))))

(map! :leader
      :desc "Org Agenda"
      "o o" #'org-agenda)
;; ("模板键" "模板描述" 类型 (目标位置) "模板内容" :选项 选项值)
;; 类型：指定捕获内容的类型，常见的有 entry（表示创建一个 Org 条目）。
;; 选项：可选参数，用于控制模板的一些行为，如 :prepend 表示是否将新条目添加到目标位置的开头。
(after! org
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* [ ] %?\n%i" :prepend t)
          ("n" "Notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i" :prepend t)

          ("a" "Authority templates")
          ("at" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* [ ] %?\n%i\n%a" :prepend t)
          ;; 类型：entry，创建一个 Org 条目。
          ;; 目标位置：(file+headline +org-capture-todo-file "Inbox")，表示将捕获的内容保存到 +org-capture-todo-file 这个文件的 "Inbox" 标题下。+org-capture-todo-file 是 Doom Emacs 中预定义的一个变量，指向待办事项文件。
          ;; 模板内容："* [ ] %?\n%i\n%a"，创建一个未完成的待办事项条目。* 表示 Org 模式中的标题级别，[ ] 表示未完成的任务标记，%? 是插入点，%i 表示插入当前选中的文本，%a 表示插入当前活动的链接。
          ;; 选项：:prepend t，表示将新的待办事项条目添加到 "Inbox" 标题下内容的开头。
          ("an" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ;; 模板内容："* %u %?"，%u 表示插入当前日期，创建一个带有日期的笔记条目。
          ("aj" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t)
          ;; 模板内容："* %U %?"，%U 表示插入当前日期和时间，创建一个带有日期和时间的日记条目

          ("p" "Templates for projects")
          ("pt" "Project-local todo" entry
           (file+headline +org-capture-project-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("pn" "Project-local notes" entry
           (file+headline +org-capture-project-notes-file "Inbox")
           "* %U %?\n%i\n%a" :prepend t)
          ("pc" "Project-local changelog" entry
           (file+headline +org-capture-project-changelog-file "Unreleased")
           "* %U %?\n%i\n%a" :prepend t)

          ("o" "Centralized templates for projects")
          ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
          ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
          ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)
          )))
;;; <<< END <<<


;;; >>> PYIM >>>
(use-package pyim
  :config
  (setq default-input-method "pyim")
  (global-set-key (kbd "C-\\") 'toggle-input-method)
  (use-package! pyim-basedict
    :ensure nil
    :config (pyim-basedict-enable))
  (setq pyim-default-scheme 'xiaohe-shuangpin)
  (setq pyim-page-length 5)
  )
(map! :after pyim
      :i "C-;" #'pyim-punctuation-toggle)
(eval-after-load 'pyim
  '(setq pyim-punctuation-translate-p '(no yes auto)))
;;; <<< END <<<


;; yasnippets
(map! :i "C-<tab>" #'yas-next-field)


;; 打开网址的默认浏览器 C-c C-o
(setq browse-url-browser-function
      (lambda (url &optional _new-window)
        (call-process "/mnt/c/Windows/System32/cmd.exe" nil 0 nil
                      "/c" "start" "" url)))

;; treemacs
(setq treemacs-git-mode 'deferred)
