# ~/.bashrc — managed by strata. Edit with: strata edit .bashrc
# Machine-only tweaks go in ~/.bashrc.local (not tracked).

[[ $- != *i* ]] && return  # not interactive: stop here

case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac

HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth
shopt -s histappend checkwinsize

# Shared with zsh.
for f in "$HOME"/.config/shell/*.sh; do [[ -f $f ]] && source "$f"; done

if command -v starship >/dev/null; then
    eval "$(starship init bash)"
else
    PS1='\[\e[36m\]\w\[\e[0m\] \$ '
fi

[[ -f "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"
