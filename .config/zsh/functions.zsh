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

function install_completions() {
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

# overwrite fzf functions that get called by trigger-sequence tabbing
# things like `vim **<tab>` run _fzf_compgen_path()
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
# $@ means all argument separated by a space
function _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$@"
}
# `cd **<tab>` runs _fzf_compgen_dir()
function _fzf_compgen_dir() {
    fd --type directory --hidden --follow --exclude ".git" . "$@"
}