#!/usr/bin/env bash
# Usage: ./install.sh [--links-only]
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

link() {
  mkdir -p "$(dirname "$2")"
  ln -sfn "$1" "$2"
  echo "$2 -> $1"
}

install_packages() {
  if [ "$OS" = Darwin ]; then
    command -v brew >/dev/null || { echo "install Homebrew first: https://brew.sh" >&2; exit 1; }
    brew install zsh git curl neovim emacs node yarn jq fzf eza lazygit btop shfmt shellcheck
    brew install --cask font-iosevka
  elif command -v apt-get >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y zsh git curl neovim emacs nodejs npm jq fzf btop shellcheck fonts-iosevka
    command -v yarn >/dev/null || sudo npm install -g yarn
    echo "note: eza, lazygit and shfmt are not installed on apt systems; the zsh aliases skip them"
  else
    echo "unsupported package manager: install the packages listed in README.md by hand" >&2
  fi
}

install_tools() {
  [ -d ~/.oh-my-zsh ] || RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  [ -d ~/.nvm ] || \
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | PROFILE=/dev/null bash
  [ -d ~/.pyenv ] || curl -fsSL https://pyenv.run | bash
}

[ "${1:-}" = --links-only ] || { install_packages; install_tools; }

link "$REPO/.emacs" ~/.emacs
link "$REPO/vim" ~/.config/nvim
link "$REPO/.zshrc" ~/.zshrc
for f in zshrc plugin alias function; do
  link "$REPO/.zsh/$f" "$HOME/.zsh/$f"
done

if [ "$OS" = Darwin ]; then
  VS=~/Library/Application\ Support/Code/User
else
  VS=~/.config/Code/User
fi
link "$REPO/.vscode/settings.json" "$VS/settings.json"
link "$REPO/.vscode/keybindings.json" "$VS/keybindings.json"
