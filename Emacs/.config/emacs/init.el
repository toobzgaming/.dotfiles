;;; package --- Summary
;;;
;;; Commentary: TODO
;;; Code:
(setq inhibit-startup-message t)
(setq use-file-dialog nil)   ;; No file dialog
(setq use-dialog-box nil)    ;; No dialog box
(setq pop-up-windows nil)    ;; No popup windows

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(menu-bar-mode -1)            ; Disable the menu bar

(electric-pair-mode 1)
(electric-indent-mode 1)
(delete-selection-mode 1)
(savehist-mode 1)

(setq visible-bell t)
(setq scroll-margin 8)
(setq-default header-line-format " ")
(setq-default line-spacing 0.1)
(setq-default fill-column 80)
(setq-default indent-tabs-mode nil)

(set-fringe-mode 20)        ; Give some breathing room
(set-default-coding-systems 'utf-8)

(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 120)
(set-face-attribute 'fixed-pitch nil :font "FiraCode Nerd Font" :height 120)
(set-face-attribute 'variable-pitch nil :font "Fira Sans" :height 140)
(when (member "Noto Color Emoji" (font-family-list))
  (set-fontset-font
   t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend))
(set-face-attribute 'font-lock-comment-face nil
                    :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
                    :slant 'italic)
(add-to-list 'default-frame-alist
             '(font . "FiraCode Nerd Font-12"))

(require 'whitespace)
(column-number-mode 1)
(global-hl-line-mode 1)
(setq display-line-numbers-width 4)
(setq display-line-numbers-width-start 4)
(setq display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'conf-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'text-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'conf-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'prog-mode-hook #'whitespace-mode)
(add-hook 'conf-mode-hook #'whitespace-mode)
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package diminish)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired))

(use-package rg
  :ensure t)

(use-package counsel-projectile
  :after projectile
  :config
  (counsel-projectile-mode 1))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom (magit-display-buffer-function
           #'magit-display-buffer-same-window-except-diff-v1))

(use-package command-log-mode)

(use-package ivy
  :diminish
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-count-format "(%d/%d) ")
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 12)
  :config
  (setq doom-modeline-icon t))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-themes
  :config (load-theme 'doom-dracula t)
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t
        (doom-themes-org-config)
        (doom-themes-visual-bell-config)))

(use-package rainbow-mode
  :diminish
  :hook org-mode prog-mode conf-mode)

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (conf-mode . rainbow-delimiters-mode)))

(use-package which-key
  :init (which-key-mode 1)
  :diminish
  :config
  (setq which-key-idle-delay 1)
  (setq which-key-add-column-padding 1)
  (setq which-key-max-description-length 24))

(use-package counsel
  :after ivy
  :diminish
  :config
  (counsel-mode))

(defun user/edit-config ()
  (interactive)
  (find-file "~/.dotfiles/Emacs/.emacs.d/init.el"))

(use-package general
  :config
  (general-create-definer user/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "M-SPC")

  (user/leader-keys
    "SPC" '(dired-jump :wk "Dired Jump")
    "RET" '(multi-term :wk "Multi Term")
    "TAB" '(counsel-switch-buffer :wk "Switch buffer")
    "`"   '(toggle-term-term :wk "Switch terminal")
    ","   '(company-complete :wk "Completion")
    "."   '(projectile-find-file :wk "Porject find")
    "/"   '(projectile-ripgrep :wk "Project regex")
    ":"   '(counsel-M-x :wk "M-x")
    ";"   '(counsel-projectile-switch-project :wk "Project Switch")
    "'"   '(format-all-region-or-buffer :wk "Format Buffer")
    "\""  '(dashboard-open :wk "Dashboard")
    "["   '(evil-prev-buffer :wk "Prev Buffer")
    "]"   '(evil-next-buffer :wk "Next Buffer"))

  (user/leader-keys
    "a"   '(:igonre t :wk "[a]pps")
    "aa"  '(ansi-term :wk "[a]nsi-term")
    "ab"  '(battery :wk "[b]attery")
    "ac"  '(calc :wk "[c]alculator")
    "aC"  '(calendar :wk "[C]alendar")
    "ad"  '(dired :wk "[d]ired")
    "aD"  '(dashboard :wk "[D]ashboard")
    "ae"  '(toggle-term-eshell :wk "[e]shell")
    "aE"  '(erc :wk "[e]rc")
    "am"  '(mail :wk "[m]ail")
    "ar"  '(rmail :wk "[r]mail")
    "ap"  '(package-install :wk "[p]ackage")
    "as"  '(toggle-term-shell :wk "[s]hell")
    "at"  '(toggle-term-term :wk "[t]erm")
    "aT"  '(multi-term :wk "multi [t]erm")
    "aw"  '(eww :wk "[w]eb")
    "aW"  '(eww-open-file :wk "[W]eb"))

  (user/leader-keys
    "aS"  '(:ignore t :wk "[s]ystem")
    "aSi"  '(iwconfig :wk "[i]wconfig")
    "aSp"  '(ping :wk "[p]ing")
    "aSd"  '(dig :wk "[d]ig")
    "aSn"  '(netstat :wk "[n]etstat")
    "aSg"  '(:ingore t :wk "[g]rep")
    "aSgl"  '(lgrep:wk "[l]grep")
    "aSgr"  '(rgrep t :wk "[r]grep")
    "aSgg"  '(grep :wk "[g]rep"))

  (user/leader-keys
    "ag"  '(:ignore t :wk "[g]ames")
    "agt" '(tetris :wk "[t]etris")
    "agb" '(bubbles :wk "[b]ubbles")
    "agB" '(blackbox :wk "[b]lackbox")
    "agd" '(doctor :wk "[d]octor")
    "agp" '(pong :wk "[p]ong")
    "agg" '(gomoku :wk "[g]omoku")
    "agm" '(mpuz :wk "[m]puz")
    "agl" '(life :wk "[l]ife")
    "ags" '(snake :wk "[s]nake")
    "agS" '(solitaire :wk "[s]olitaire")
    "agd" '(dunnet :wk "[d]unnet"))

  (user/leader-keys
    "b"   '(:ignore t :wk "[b]uffers")
    "bb"  '(counsel-ibuffer :wk "[b]uffer menu")
    "bB"  '(buffer-menu :wk "[b]uffers buffer")
    "bc"  '(kill-current-buffer :wk "[c]lose buffer")
    "be"  '(evil-buffer-new :wk "buffer new")
    "bs"  '(save-buffer :wk "[s]ave cbuffer")
    "bp"  '(previous-buffer :wk "[p]revious buffer")
    "bn"  '(next-buffer :wk "[n]ext buffer"))

  (user/leader-keys
    "c"   '(:ignore t :wk "[c]ode"))

  (user/leader-keys
    "d"   '(:ignore t :wk "[d]ebug/[d]iff")
    "db"  '(debug :wk "de[b]ug")
    "dd"  '(ediff-directories :wk "[d]irs")
    "df"  '(ediff-files :wk "[f]iles")
    )

  (user/leader-keys
    "e"   '(:ignore t :wk "[e]dit/sudo")
    "ee"  '(evil-edit :wk "[e]vil")
    "ec"  '(user/edit-config  :wk "[c]onfig")
    "es"  '(:ignore t :wk "[s]udo")
    "esf" '(sudo-edit-find-file :wk "[f]ind")
    "esb" '(sudo-edit :wk "[b]uffer")
    "et"   '(:ignore t :wk "[t]oggle")
    "ets"  '(ediff-toggle-split :wk "[s]plit")
    "etf"  '(ediff-toggle-multiframe :wk "[f]rame"))

  (user/leader-keys
    "E"   '(:ignore t :wk "[E]rror")
    "En"  '(next-error :wk "[n]ext")
    "Ep"  '(previous-error :wk "[p]rev")
    "Es"   '(:ignore t :wk "[s]pell")
    "Esn"  '(evil-next-flyspell-error :wk "[n]ext")
    "Esp"  '(evil-prev-flyspell-error :wk "[p]rev"))

  (user/leader-keys
    "f"   '(:ignore t :wk "[f]ind")
    "f."  '(find-file-at-point :wk "ffap")
    "fa"  '(counsel-apropos :wk "[a]propos")
    "fb"  '(counsel-ibuffer :wk "[b]uffer")
    "fe"  '(counsel-flycheck :wk "[e]rror")
    "ff"  '(counsel-file-jump :wk "[f]ile")
    "fF"  '(counsel-fonts :wk "[F]onts")
    "fi"  '(counsel-imenu :wk "[i]menu")
    "ft"  '(counsel-rg :wk "[t]ext")
    "fk"  '(hl-todo-rgrep :wk "[k]eyword")
    "fm"  '(counsel-evil-marks :wk "[m]arks")
    "fr"  '(counsel-evil-registers :wk "[r]egisters")
    "fp"  '(counsel-projectile :wk "[p]rojectile")
    "fP"  '(counsel-package :wk "[p]ackage")
    "fo"  '(counsel-org-file :wk "[o]rg")
    "fx"  '(counsel-linux-app :wk "[x]dg-app"))

  (user/leader-keys
    "g"   '(:ignore t :wk "[g]it")
    "gb"  '(magit-branch :wk "[b]ranch")
    "gc"  '(magit-commit :wk "[c]ommit")
    "gC"  '(magit-clone :wk "[c]lone")
    "gs"  '(magit-status :wk "[s]tatus")
    "gS"  '(magit-stash :wk "[s]tash")
    "gl"  '(magit-log :wk "[l]og")
    "gL"  '(magit-reflog-current :wk "[r]eflog")
    "gi"  '(magit-gitignore :wk "[i]gnore")
    "gI"  '(magit-init :wk "[i]nit")
    "gp"  '(magit-pull :wk "[p]ull")
    "gP"  '(magit-push :wk "[p]ush")
    "gg"  '(magit-dispatch :wk "ma[g]it")
    "gr"  '(magit-rebase :wk "[r]ebase")
    "gR"  '(magit-reset :wk "[R]eset")
    "gd"  '(magit-diff :wk "[d]iff")
    "gt"  '(magit-tag :wk "[t]ag")
    "gm"  '(magit-merge :wk "[m]erge")
    "gx"  '(magit-remote :wk "remote")
    "gw"  '(magit-worktree :wk "[w]orktree"))

  (user/leader-keys
    "h"   '(:ignore t :wk "[h]elp")
    "h?"  '(help-for-help :wk "Help4help")
    "hd"  '(:ignore t :wk "[d]escribe")
    "hdb"  '(describe-bindings :wk "[b]indings")
    "hdc"  '(describe-command :wk "[c]ommand")
    "hdf"  '(describe-function :wk "[f]unction")
    "hdk"  '(describe-key :wk "[k]ey")
    "hdl"  '(describe-language-environment :wk "[l]anguage env")
    "hdm"  '(describe-mode :wk "[m]ode")
    "hdo"  '(descibe-symbol :wk "symb[o]l")
    "hdp"  '(describe-package :wk "[p]ackage")
    "hds"  '(describe-syntax :wk "[s]yntax")
    "hdv"  '(describe-variable :wk "[v]ariable")
    "hi"  '(info :wk "[i]nfo")
    "hm"  '(man :wk "[m]an pages")
    "ht"  '(tldr :wk "[t]ldr")
    "hw"  '(woman :wk "[w]oman")
    "hD"  '(dictionary) :wk "[d]ictionary")

  (user/leader-keys
    "i"   '(:ignore t :wk "[i]nsert")
    "ie"  '(emoji-insert :wk "[e]moji")
    "iE"  '(emojify-insert-emoji :wk "[e]moji")
    "ii"  '(all-the-icons-insert :wk "all [i]cons")
    "in"  '(nerd-icons-insert :wk "[n]erd icons")
    "it"  '(org-time-stamp :wk "[t]imestamp")
    "iT"  '(org-time-stamp-inactive :wk "timestamp inactive"))

  (user/leader-keys
    "j"   '(:ignore t :wk "[j]"))

  (user/leader-keys
    "k"   '(:ignore t :wk "[k]"))

  (user/leader-keys
    "l"   '(:ignore t :wk "[l]sp")
    "ll"  '(lsp :wk "[l]sp")
    "le"  '(eglot :wk "[e]glot")
    "lu" '(lsp-ui-mode :wk "lsp-[u]i"))

  (user/leader-keys
    "m"   '(:ignore t :wk "[m]ode")
    "mc"  '(flycheck-mode :wk "fly[c]heck")
    "md"  '(rainbow-delimiters-mode :wk "[d]elimiters")
    "me"  '(:ignore t :wk "[e]vil")
    "mee"  '(evil-emacs-state :wk "[e]macs")
    "mev"  '(evil-mode :wk "e[v]il")
    "mes"  '(evil-snipe-mode :wk "[s]nipe")
    "mey"  '(evil-surround-mode :wk "surround")
    "mec"  '(evil-commentary-mode :wk "[c]ommentary")
    "mw"  '(writeroom-mode :wk "[w]riteroom")
    "mc" '(command-log-mode :wk "[c]ommand")
    "mt" '(tabify :wk "[t]abify")
    "mr" '(rainbow-mode :wk "[r]ainbow")
    "mR" '(read-only-mode :wk "[r]eadonly")
    "mu" '(untabify :wk "[u]ntabify")
    "mf" '(flyspell-mode :wk "[f]lyspell")
    "mF" '(format-all-mode :wk "[f]ormat")
    "ml" '(display-line-numbers-mode :wk "[l]inenum")
    "mv" '(display-fill-column-indicator-mode :wk "[v]isual fill"))

  (user/leader-keys
    "n"   '(:ignore t :wk "[n]"))

  (user/leader-keys
    "o"   '(:ignore t :wk "[o]rg")
    "oa"  '(org-agenda :wk "[a]genda")
    "oe"  '(org-export-dispatch :wk "[e]xport")
    "oB"  '(:ignore :wk "[b]abel")
    "oi"  '(:ignore t :wk "[i]nsert")
    "oit" '(org-insert-time-stamp :wk "[t]imestamp")
    "oil" '(org-insert-link :wk "[l]ink")
    "oia" '(org-insert-all-links :wk "[a]ll")
    "ois" '(org-insert-last-stored-link :wk "[s]tored link")
    "oig" '(org-insert-link-global :wk "[g]lobal link")
    "oid" '(org-insert-drawer :wk "[d]rawer")
    "ol"  '(:ignore t :wk "[l]ink")
    "ols" '(org-store-link :wk "[s]tore")
    "olS" '(org-id-store-link :wk "[s]tore id")
    "olo" '(org-link-open-from-string :wk "[o]pen")
    "oo"  '(org-open-at-point :wk "[o]pen")
    "oO"  '(org-open-at-point-global :wk "[o]pen global")
    "oT"  '(:ignore t :wk "[t]oggle")
    "oTd" '(org-toggle-timestamp-type :wk "[d]ate")
    "oTt" '(toc-org-mode :wk "[t]oc")
    "ot"  '(:ignore t :wk "[t]imer")
    "ott" '(org-timer-set-timer :wk "se[t]")
    "oti" '(org-timer :wk "[i]nsert")
    "otp" '(org-timer-pause-or-continue :wk "[p]ause")
    "otT" '(org-timer-stop :wk "s[t]op"))

  (user/leader-keys
    "O" '(:ignore t :wk "[o]pen")
    "Of" '(ffap :wk "[f]ile")
    "Ow" '(eww-follow-link :wk "[w]eb")
    "Ox" '(browse-url-xdg-open :wk "[x]dg")
    )

  (user/leader-keys
    "p"   '(:ignore t :wk "[p]roject")
    "p."  '(projectile-dired-other-window :wk "dired")
    "p/"  '(projectile-ripgrep :wk "ripgrep")
    "p;"  '(projectile-switch-project :wk "project")
    "pf"  '(projectile-find-file-other-window :wk "[f]ile")
    "pd"  '(projectile-dired-other-window :wk "[d]ired")
    "ps"  '(projectile-switch-project :wk "[s]witch"))

  (user/leader-keys
    "q"   '(:ignore t :wk "[q]"))

  (user/leader-keys
    "r"   '(:ignore t :wk "[r]"))

  (user/leader-keys
    "s"   '(:ignore t :wk "[s]how")
    "sb"  '(battery :wk "[b]attery")
    "so"  '(occur :wk "[o]ccur")
    "sh"  '(holidays :wk "[h]olidays")
    "sf"  '(fortune :wk "[f]ortune"))

  (user/leader-keys
    "t"   '(:ignore t :wk "[t]oggles")
    "tc"  '(clm/toggle-command-log-buffer :wk "Log [c]ommands")
    "te"  '(toggle-term-eshell :wk "[e]shell")
    "tF"  '(toggle-frame-fullscreen :wk "[f]ullscreen")
    "tM"  '(toggle-frame-maximized :wk "[m]aximize")
    "ts"  '(toggle-term-shell :wk "[s]hell")
    "tt"  '(toggle-term-term :wk "[t]erm")
    "tT"  '(counsel-load-theme :wk "[t]heme")
    "tp"  '(org-tree-slide-mode :wk "[p]resentation")
    "tu"  '(undo-tree-visualize :wk "[u]ndo")
    "ti"  '(ispell :wk "i[s]pell check")
    "tw"  '(toggle-word-wrap :wk "[w]rap"))

  (user/leader-keys
    "u"   '(:ignore t :wk "[u]"))

  (user/leader-keys
    "v"   '(:ignore t :wk "[v]"))

  (user/leader-keys
    "w"   '(:ignore t :wk "[w]indow")
    "wc"  '(kill-buffer-and-window :wk "[c]lose")
    "ws"  '(:ignore t :wk "[s]plit")
    "wsv"  '(split-window-vertically :wk "[v]ertically")
    "wsh"  '(split-window-horizontally :wk "[h]orizontally")
    "wM"  '(maximize-window :wk "[M]aximize")
    "wm"  '(:igonre t :wk "[m]ove")
    "wmh" '(evil-window-move-far-left :wk "[h]/left")
    "wmj" '(evil-window-move-very-bottom :wk "[j]/down")
    "wmk" '(evil-window-move-very-top :wk "[k]/up")
    "wml" '(evil-window-move-very-right :wk "[l]/right")
    "wh"  '(:ignore t :wk "[h]eight")
    "whi" '(evil-window-increase-height :wk "[i]ncrease")
    "whd" '(evil-window-decrease-height :wk "[d]ecrease")
    "whs" '(evil-window-set-height :wk "[s]et")
    "ww"  '(:ignore t :wk "[w]idth")
    "wwi" '(evil-window-increase-width :wk "[i]ncrease")
    "wwd" '(evil-window-decrease-width :wk "[d]ecrease")
    "wws" '(evil-window-set-width :wk "[s]et"))

  (user/leader-keys
    "x"   '(:ignore t :wk "[x]"))

  (user/leader-keys
    "y"   '(:ignore t :wk "[y]"))

  (user/leader-keys
    "z"   '(:igonre t :wk "[z]")))

(defun user/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "H") 'evil-prev-buffer)
  (define-key evil-normal-state-map (kbd "L") 'evil-next-buffer)
  (evil-global-set-key 'motion "gs" 'evil-avy-goto-char-2)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-snipe
  :ensure t
  :after evil
  :config
  (setq evil-snipe-scope 'whole-buffer)
  (setq evil-snipe-repeat-scope 'whole-buffer)
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1))

(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-surround
  :ensure t
  :after evil
  :config
  (global-evil-surround-mode 1))

(defun user/org-mode-setup ()
  (org-indent-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . user/org-mode-setup)
  :config
  (setq org-hide-emphasis-markers t)
  (setq org-src-preserve-indentation t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

(require 'org-indent)
(require 'org-tempo)

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-tree-slide
  :custom
  (org-image-actual-width nil))

(defun user/presentation-setup ()
  (org-display-inline-images 1)
  (display-line-numbers-mode 0)
  (setq text-scale-mode-amount 3)
  (text-scale-mode 1)
  (beacon-mode 0))

(defun user/presentation-end ()
  (org-display-inline-images 0)
  (display-line-numbers-mode 1)
  (text-scale-mode 0)
  (beacon-mode 1))

(use-package org-tree-slide
  :hook ((org-tree-slide-play . user/presentation-setup)
         (org-tree-slide-stop . user/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect t)
  (org-tree-slide-activate-message "Presentation started!")
  (org-tree-slide-deactivate-message "Presentation finished!")
  (org-tree-slide-header t)
  (org-tree-slide-breadrums " > ")
  (org-image-actual-width nil))

(use-package tldr)

(use-package format-all
  :commands format-all-mode
  :hook ((prog-mode . format-all-mode)
         (conf-mode . format-all-mode))
  :config
  (setq-default format-all-formatters
                '(("C"     (astyle "--mode=c"))
                  ("Shell" (shfmt "-i" "4" "-ci")))))

(use-package lsp-mode
  :commands (lsp lsp-deffered)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  )

(use-package company
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0))

(use-package company-box
  :hook (companyy-mode . company-box-mode))

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-position 'bottom)
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-sideline-show-hover nil)
  )


(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package term
  :config
  (setq explicit-shell-file-name "/bin/bash"))

(use-package multi-term
  :config
  (setq multi-term-program "/bin/bash"))

(use-package toggle-term
  :bind (("M-o f" . toggle-term-find)
         ("M-o t" . toggle-term-term)
         ("M-o v" . toggle-term-vterm)
         ("M-o a" . toggle-term-eat)
         ("M-o s" . toggle-term-shell)
         ("M-o e" . toggle-term-eshell)
         ("M-o i" . toggle-term-ielm)
         ("M-o o" . toggle-term-toggle))
  :config
  (setq toggle-term-size 25)
  (setq toggle-term-switch-upon-toggle t))

(defun user/configure-eshell ()
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (evil-define-key
    '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key
    '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)

  (setq eshell-history-size 10000
        eshell-buffer-maximum-lines 10000
        eshell-scroll-to-bottom-on-input t))

(use-package eshell
  :hook (eshell-first-time-mode . user/configure-eshell))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package auto-package-update)

(use-package undo-tree
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1)
  (evil-collection-define-key
    '(normal visual) 'global-map "g;" 'goto-last-change)
  (evil-collection-define-key
    '(normal visual) 'global-map "g," 'goto-last-change-reverse))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-items '((recents   . 5)
                          (projects  . 5)
                          (agenda    . 5)))
  (dashboard-setup-startup-hook))

(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))

(use-package avy)

(use-package emojify
  :hook (after-init . global-emojify-mode))

(use-package hl-todo
  :hook ((org-mode . hl-todo-mode)
         (prog-mode . hl-todo-mode))
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

(use-package sudo-edit)

(use-package writeroom-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "48042425e84cd92184837e01d0b4fe9f912d875c43021c3bcb7eeb51f1be5710" default))
 '(package-selected-packages
   '(hl-todo toggle-term format-all evil-surround auto-package-update dired-hide-dotfiles dired-open all-the-icons-dired dired-single lsp-ivy lsp-ui company-box company lsp-mode evil-collection evil general counsel ivy-rich which-key rainbow-delimiters doom-modeline ivy command-log-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
