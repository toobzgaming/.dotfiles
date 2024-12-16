if status is-interactive
    # Commands to run in interactive sessions can go here
end
# Vi style keybindings
fish_vi_key_bindings

source $HOME/.config/sh/alias.sh
source $HOME/.config/sh/export.sh

neofetch

starship init fish | source

