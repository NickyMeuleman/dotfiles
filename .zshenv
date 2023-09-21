# windows terminal doesn't set this for some reason
[[ -n $WT_SESSION ]] && export COLORTERM="truecolor"

# shortcuts to often used folders
export DOTFILES=$HOME/dotfiles
export ZDIR=$HOME/.config/zsh
export ZSHRC=$HOME/.zshrc
export ZSHENV=$HOME/.zshenv

# general
path+=("$HOME/.local/bin")

# Rust language
. "$HOME/.cargo/env"

# fnm
path+=("$HOME/.local/share/fnm")

# Golang
path+=("/usr/local/go/bin")

# Add custom completions dir to fpath
fpath+=("$ZDIR/completions")

# use bat as colorizing pager for `man`
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
# allow mouse scrolling in bat pager
# export BAT_PAGER="less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse"

# fzf
# use fd as default finder
export FZF_DEFAULT_COMMAND="fd \
--exclude .git \
--follow \
--hidden \
--strip-cwd-prefix \
--type file"
# catppuccin frappe theme + extra options
export FZF_DEFAULT_OPTS=" \
--border \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
--cycle \
--height 75% \
--layout=reverse"
# CTRL-t
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
# Preview file content using bat (https://github.com/sharkdp/bat)
# get rid of the borders around the bat preview
# CTRL-/ to toggle preview window visibility/location
export FZF_CTRL_T_OPTS=" \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
--preview 'bat --color=always --line-range=:500 --number {}'"
# ALT-c
export FZF_ALT_C_COMMAND="fd \
--type directory \
--strip-cwd-prefix \
--hidden \
--exclude .git \
--color=never"
# Print tree structure in the preview window
# CTRL-/ to toggle small preview window with the tree
export FZF_ALT_C_OPTS=" \
--bind 'ctrl-/:toggle-preview' \
--preview 'exa --color=always --icons --level 3 --tree {}'"
# CTRL-/ to toggle small preview window to see the full command
# CTRL-y to copy the command into the Windows clipboard
export FZF_CTRL_R_OPTS=" \
--bind 'ctrl-/:toggle-preview' \
--bind 'ctrl-y:execute-silent(echo -n {2..} | clip.exe)+abort' \
--color header:italic \
--header 'Press CTRL-Y to copy command into OS clipboard' \
--preview 'echo {2..} | bat --color=always --language=sh --line-range=:500 --plain' \
--preview-window up:3:hidden:wrap"

# zoxide
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
--exit-0 \
--no-multi \
--no-sort \
--preview 'exa --color=always --icons --level 3 --tree {2..}' \
--select-1"

export PATH
export fpath
export GTK_THEME=Catppuccin-Frappe-Standard-Blue-Dark
export QT_STYLE_OVERRIDE=kvantum
