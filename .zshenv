# windows terminal doesn't set this for some reason
[[ -n $WT_SESSION ]] && export COLORTERM="truecolor"

# shortcuts to often used folders
export DOTFILES=$HOME/dotfiles
export ZDIR=$HOME/.config/zsh
export ZSHRC=$HOME/.zshrc
export ZSHENV=$HOME/.zshenv

# Rust language
. "$HOME/.cargo/env"

# fnm
path+=("$HOME/.local/share/fnm")

# zoxide
path+=("$HOME/.local/bin")

# Golang
path+=(/usr/local/go/bin)

export PATH
