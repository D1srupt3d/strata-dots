# ~/.zshrc — managed by strata. Edit with: strata edit .zshrc
# Machine-only tweaks go in ~/.zshrc.local (not tracked).

typeset -U path
path=("$HOME/.local/bin" $path)

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

bindkey -e  # emacs keys (Ctrl-A, Ctrl-E, Ctrl-R); use -v for vi mode

# Shared with bash. The (N) glob flag means "no error if nothing matches".
for f in "$HOME"/.config/shell/*.sh(N); do source "$f"; done

if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
else
    PROMPT='%F{cyan}%~%f %# '
fi

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
