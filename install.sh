#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"

link() {
  mkdir -p "$(dirname "$2")"
  ln -sfn "$1" "$2"
  echo "$2 -> $1"
}

link "$REPO/.emacs" ~/.emacs
link "$REPO/vim" ~/.config/nvim
VS=~/Library/Application\ Support/Code/User
link "$REPO/.vscode/settings.json" "$VS/settings.json"
link "$REPO/.vscode/keybindings.json" "$VS/keybindings.json"
