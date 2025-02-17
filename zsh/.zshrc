# Only run in interactive mode.
[[ $- != *i* ]] && return

# The following lines were added by compinstall
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original false
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt 'Corrections: %e'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/nicky/.zshrc'
# End of lines added by compinstall

# Lines configured by zsh-newuser-install
setopt notify
unsetopt beep
# End of lines configured by zsh-newuser-install

# History settings
HISTFILE=$ZDIR/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# vim bindings
bindkey -v

# Enable the completion system, suppress alias expansion with -U
autoload -Uz compinit

# Initialize all completions on $fpath and ignore (-i) all insecure files and directories
# so: only load completion files the current user owns
compinit -i

# Helper functions
source "$ZDIR/functions.zsh"

# Aliases
zsh_add_file "aliases.zsh"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_file "plugins/catppuccin-zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"
# syntax highlighting plugin must be last one
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Prompt: starship
eval "$(starship init zsh)"

# node manager: fnm
FNM_PATH="/home/nicky/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/nicky/.local/share/fnm:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# pnpm
export PNPM_HOME="/home/nicky/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# fuzzy finder: fzf
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

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

fastfetch
