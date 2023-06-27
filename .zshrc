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

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zdharma-continuum/fast-syntax-highlighting"

# Aliases
zsh_add_file "aliases.zsh"

# Prompt
eval "$(starship init zsh)"

# fnm
export PATH="/home/nicky/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"
