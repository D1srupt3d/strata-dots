# macOS only — replaces base/.config/shell/os.sh on Macs.

# Homebrew: Apple Silicon first, then Intel.
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$brew" ] && eval "$("$brew" shellenv)" && break
done

export CLICOLOR=1  # colored ls
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
