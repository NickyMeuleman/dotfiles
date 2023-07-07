function zsh_add_file() {
    [ -f "$ZDIR/$1" ] && source "$ZDIR/$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDIR/plugins/$PLUGIN_NAME" ]; then 
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDIR/plugins/$PLUGIN_NAME"
    fi
}

function zsh_add_completion() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDIR/plugins/$PLUGIN_NAME" ]; then 
		completion_file_path=$(ls $ZDIR/plugins/$PLUGIN_NAME/_*)
		fpath+="$(dirname "${completion_file_path}")"
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDIR/plugins/$PLUGIN_NAME"
		fpath+=$(ls $ZDIR/plugins/$PLUGIN_NAME/_*)
        [ -f $ZDIR/.zccompdump ] && $ZDIR/.zccompdump
    fi
	completion_file="$(basename "${completion_file_path}")"
	if [ "$2" = true ] && compinit "${completion_file:1}"
}

# Only run in interactive mode.
[[ $- != *i* ]] && return

# History settings
HISTFILE=$ZDIR/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# vim bindings
bindkey -v

# Add custom completions dir to fpath
fpath=($ZDIR/completions $fpath)

# Enable the completion system
autoload compinit

# Initialize all completions on $fpath and ignore (-i) all insecure files and directories
compinit -i

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
# clone https://github.com/catppuccin/zsh-syntax-highlighting to $ZDIR/plugins first
# tip: the gh cli is conventient for this: 
# gh repo clone catppuccin/zsh-syntax-highlighting $ZDIR/plugins/catppuccin-zsh-syntax-highlighting
zsh_add_file "plugins/catppuccin-zsh-syntax-highlighting/themes/catppuccin_frappe-zsh-syntax-highlighting.zsh"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
# Until I investigate catppuccin for zdharma, use zsh-users syntax highlighting
# zsh_add_plugin "zdharma-continuum/fast-syntax-highlighting"

# Aliases
zsh_add_file "aliases.zsh"

# Prompt: starship
# generate completions file, only needs to be ran once per update of starship
# starship completions zsh > $ZDIR/completions/_starship
eval "$(starship init zsh)"

# node manager: fnm
eval "$(fnm env --use-on-cd)"
# generate completions file, only needs to be ran once per update of fnm
# fnm completions --shell=zsh > $ZDIR/completions/_fnm

# fuzzy finder: fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
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
# overwrite fzf functions that get called by trigger-sequence tabbing
# things like `vim **<tab>` run _fzf_compgen_path()
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$@"
}
# `cd **<tab>` runs _fzf_compgen_dir()
_fzf_compgen_dir() {
    fd --type directory --hidden --follow --exclude ".git" . "$@"
}

# smart cd: zoxide
eval "$(zoxide init zsh)"
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS \
--no-multi \
--no-sort \
--exit-0 \
--select-1 \
--preview 'exa --color=always --tree --level 3 --icons {2..}' \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
"

# find replacement: fd
# generate symlink from fdfind to fd, only needs to be ran once per update of fd-find
# ln -s $(which fdfind) ~/.local/bin/fd

# use wslview instead of xdg-open to open everything that uses xdg-open in windows
# examples:
#  - xdg-open https://google.com opens the default internet browser on windows
#  - xdg-open a-video.mp4 opens the default video player on windows
#  - xdg-open a-photo.jpg opens the default image viewer on windows
# create a symlink to where xdg-open would normally be (protected route, so sudo is needed)
# only create symlink once per install, run this manually instead of uncommenting
# sudo ln -s $(which wslview) /usr/local/bin/xdg-open

# Rust language
# generate completions file, only needs to be ran once per update of rustup
# rustup completions zsh > $ZDIR/completions/_rustup
# generate completions file, only needs to be ran once per update of cargo
# rustup completions zsh cargo > $ZDIR/completions/_cargo

# better cat: bat
# if you installed via apt, the bat binary might be named batcat
# make `bat` available by symlinking it as `bat` into a spot that's in the PATH
# mkdir -p ~/.local/bin
# ln -s /usr/bin/batcat ~/.local/bin/bat
# use bat as colorizing pager fan `man`
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# allow mouse scrolling in bat pager
export BAT_PAGER="less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse"