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

# Add custom completions dir to fpath
fpath+=($ZDIR/completions)

# use bat as colorizing pager for `man`
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# allow mouse scrolling in bat pager
export BAT_PAGER="less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse"

# fzf
# add catppuccin latte theme + extra options
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
--height 75% \
--layout=reverse \
--border \
--cycle"
# use fd as default finder
export FZF_DEFAULT_COMMAND="fd \
--type file \
--follow \
--hidden \
--exclude .git \
--strip-cwd-prefix"
# fzf ctrl-t hotkey
# Preview file content using bat (https://github.com/sharkdp/bat)
# get rid of the lines around the bat window, and bind a key to toggle where the preview is shown
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS=" \
--preview 'bat --number --color=always --line-range=:500 {}' \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
--cycle"
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into the Windows clipboard
export FZF_CTRL_R_OPTS=" \
--preview 'echo {2..} | bat --plain --language=sh --color=always --line-range=:500' --preview-window up:3:hidden:wrap \
--bind 'ctrl-/:toggle-preview' \
--bind 'ctrl-y:execute-silent(echo -n {2..} | clip.exe)+abort' \
--color header:italic \
--header 'Press CTRL-Y to copy command into OS clipboard' \
--cycle"
# Print tree structure in the preview window
# CTRL-/ to toggle small preview window with the tree
export FZF_ALT_C_COMMAND="fd \
--type directory \
--strip-cwd-prefix \
--hidden \
--exclude .git \
--color=never"
export FZF_ALT_C_OPTS=" \
--preview 'exa --color=always --tree --level 3 --icons {}'
--bind 'ctrl-/:toggle-preview' \
--cycle"

# zoxide
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS \
--no-multi \
--no-sort \
--exit-0 \
--select-1 \
--preview 'exa --color=always --tree --level 3 --icons {2..}' \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
"

export PATH
export fpath