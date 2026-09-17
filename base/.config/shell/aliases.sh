# Aliases shared by zsh and bash on every machine. Keep this POSIX-ish.
# Changing this file triggers the demo hook in dots.toml.

export EDITOR="${EDITOR:-vi}"

alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah'
alias la='ls -A'

alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'

# strata
alias st='strata status'
alias sd='strata diff'
alias sa='strata apply'

mkcd() { mkdir -p "$1" && cd "$1"; }
