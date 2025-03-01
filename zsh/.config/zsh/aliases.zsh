# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias ~="cd ~"

# Listing files in the current directory
alias ezabase="\
eza \
--long \
--classify \
--color=auto \
--icons \
--sort=name \
--group-directories-first \
--header \
--modified \
--time-style=default \
"
# short base (that really uses --long with some info stripped away)
alias ls="ezabase --no-user --no-permissions "
alias l="ls"
alias la="ls --all"
# long base
alias ll="ezabase --group --links --inode"
alias lla="ll --all"
# short tree
alias lt="ezabase --tree --level=3"
alias lta="lt --all"
# long tree
alias llt="ll --tree --level=3"
alias llta="llt --all"

# use bat instead of cat
alias cat="bat --paging=never"

# less typing is good
alias n="nvim"
