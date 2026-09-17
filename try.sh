#!/bin/sh
# Try this repo with strata WITHOUT touching your real home directory.
# Everything lands in ./.sandbox/ (gitignored). It lives at the repo root,
# outside every layer, so strata never copies it into $HOME.
#
#   ./try.sh                 first run: set up the sandbox and apply
#   ./try.sh                 after that: open the strata TUI
#   ./try.sh <command>       any strata command: status, diff, apply, edit .zshrc …
#   LAYERS=work ./try.sh     first run as a "work" machine
#   ./try.sh reset           delete the sandbox and start over
set -eu

repo="$(cd "$(dirname "$0")" && pwd)"
sandbox="$repo/.sandbox"

if [ "${1:-}" = reset ]; then
    rm -rf "$sandbox"
    echo "sandbox removed"
    exit 0
fi

if ! command -v strata >/dev/null 2>&1; then
    echo "strata isn't installed. Install it with:" >&2
    echo "  curl -fsSL https://raw.githubusercontent.com/D1srupt3d/strata/main/get.sh | sh" >&2
    exit 1
fi

# These three variables point strata at the sandbox instead of your real
# home, machine.toml and state file.
export STRATA_HOME="$sandbox/home"
export STRATA_CONFIG="$sandbox/machine.toml"
export STRATA_STATE="$sandbox/state.json"

if [ ! -f "$STRATA_CONFIG" ]; then
    mkdir -p "$STRATA_HOME"
    strata init --repo "$repo" --layers "${LAYERS:-}"
    echo
    echo "sandbox ready: look around in $STRATA_HOME"
    echo "next: ./try.sh   (TUI)   or   ./try.sh status"
    exit 0
fi

exec strata "$@"
