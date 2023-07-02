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
eval "$(starship init zsh)"

# node manager: fnm
eval "$(fnm env --use-on-cd)"
# generate completions file, only needs to be ran once per update of fnm
# fnm completions --shell=zsh > $ZDIR/completions/_fnm

# smart cd: zoxide
eval "$(zoxide init zsh)"

# fuzzy finder: fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# catppuccin latte theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
# use fd as default finder
export FZF_DEFAULT_COMMAND='fd --type file'

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