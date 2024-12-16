# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000

bindkey -v
setopt autocd autopushd pushdignoredups

autosuggestionspath="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
syntaxhighlightingpath="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
historysubstringpath="/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
[ -f $autosuggestionspath ] && source $autosuggestionspath
[ -f $syntaxhighlightingpath ] && source $syntaxhighlightingpath
[ -f $historysubstringpath ] && source $historysubstringpath


[ -f  "$HOME/.config/sh/alias.sh" ] && source "$HOME/.config/sh/alias.sh"
[ -f  "$HOME/.config/sh/export.sh" ] && source "$HOME/.config/sh/export.sh"
[ -f  "$HOME/.config/sh/function.sh" ] && source "$HOME/.config/sh/function.sh"

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ani/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
zstyle ':completion:*' menu select
if command -v starship>/dev/null; then
eval "$(starship init zsh)"
fi
if command -v zoxide>/dev/null; then
eval "$(zoxide init zsh)"
fi
if command -v fastfetch>/dev/null; then
fastfetch
fi

[ -f "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"

# bun completions
[ -s "/home/ani/.bun/_bun" ] && source "/home/ani/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -f  "/usr/share/fzf/completion.zsh" ] && source "/usr/share/fzf/completion.zsh"
[ -f  "/usr/share/fzf/key-bindings.zsh" ] && source "/usr/share/fzf/key-bindings.zsh"
if command -v fzf-share >/dev/null; then
    source "$(fzf-share)/completion.zsh"
    source "$(fzf-share)/key-bindings.zsh"
fi

# opam configuration
[[ ! -r /home/ani/.opam/opam-init/init.zsh ]] || source /home/ani/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

zle -N             sesh-connect
bindkey -M emacs '\et' sesh-connect
bindkey -M vicmd '\et' sesh-connect
bindkey -M viins '\et' sesh-connect

GUIX_PROFILE="/home/toobzgaming/.guix-profile"
     . "$GUIX_PROFILE/etc/profile"
