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

# Helper functions
source "$ZDIR/functions.zsh"

# Aliases
zsh_add_file "aliases.zsh"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_file "plugins/catppuccin-zsh-syntax-highlighting/themes/catppuccin_frappe-zsh-syntax-highlighting.zsh"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Prompt: starship
eval "$(starship init zsh)"

# node manager: fnm
eval "$(fnm env --use-on-cd)"

# fuzzy finder: fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# Run commands at startup
macchina