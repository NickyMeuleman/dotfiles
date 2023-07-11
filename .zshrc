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

# Only run in interactive mode.
[[ $- != *i* ]] && return

# History settings
HISTFILE=$ZDIR/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# vim bindings
bindkey -v

# Enable the completion system, suppress alias expansion with -U
autoload -U compinit

# Initialize all completions on $fpath and ignore (-i) all insecure files and directories
# so: only load completion files the current user owns
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

# fuzzy finder: fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# better cat: bat
# if you installed via apt, the bat binary might be named batcat
# make `bat` available by symlinking it as `bat` into a spot that's in the PATH
# mkdir -p ~/.local/bin
# ln -s /usr/bin/batcat ~/.local/bin/bat

install_completions() {
    # prompt: starship
    starship completions zsh > $ZDIR/completions/_starship
    # GitHub CLI: gh
    gh completion -s zsh > $ZDIR/completions/_gh
    # Rust language: rustup
    rustup completions zsh > $ZDIR/completions/_rustup
    # Rust language package tool: cargo
    rustup completions zsh cargo > $ZDIR/completions/_cargo
    # node manager: fnm
    fnm completions --shell=zsh > $ZDIR/completions/_fnm
    # better cat: bat
    echo 'manually copy bat completions from the /out/assets/completions folder inside target/release'
    # smart cd: zoxide
    echo 'manually copy zoxide completions from the /contrib/completions folder'
}