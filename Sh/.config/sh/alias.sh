# Editors

alias -- -='cd -'

alias md='mkdir -p'
alias rd=rmdir

alias _="sudo "

alias nv=nvim
alias es="emacs -nw"
alias ec="emacsclient -tqua ''"

if [ "$WAYLAND_DISPLAY" = "" ]; then
	alias neovide="neovide"
else
	alias neovide="env -u WAYLAND_DISPLAY neovide"
fi
alias gvi=gvim
alias ges="launch emacs"
alias gec="launch emacsclient -caua ''"
alias gnv=neovide
if command -v codium >/dev/null; then
alias code=codium
fi
# Dotfiles
alias dotcfg="/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME"
# Man / Tldr
alias manf="man -k . | awk -F ' - ' '{print \$1}' | fzf --preview 'man {1}' --preview-window=right,70% | xargs man"
alias tldrf="tldr --list | fzf --preview 'tldr {1} --color=always' --preview-window=right,70% | xargs tldr"
alias info="info --vi-keys"
# Utils
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias ls="ls -h --color=auto --group-directories-first"
if command -v lsd>/dev/null; then
    alias ls=lsd
fi
alias lg=lazygit
alias lgit=lazygit

alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias cp="cp -i"     # confirm before overwriting something
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB
if command -v moar>/dev/null; then
alias more=moar
alias less=moar
fi
alias db=distrobox
if command -v bat>/dev/null; then
alias cat=bat
fi
if command -v fastfetch>/dev/null; then
alias ff=fastfetch
fi
alias datef="date -u +%a,\ %Y-%b-%d"
alias datetimef="date -u +%a,\ %Y-%b-%d%n%H:%M\ \(%Z\)"
