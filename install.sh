#!/usr/bin/env bash
set -e

DOTFILES=$HOME/dotfiles

echo "[install] linking dotfiles from $DOTFILES"

# bashrc
ln -sf $DOTFILES/.bashrc $HOME/.bashrc
mkdir -p $HOME/.bashrc.d
ln -sf $DOTFILES/.bashrc.d/dev.sh $HOME/.bashrc.d/dev.sh

# dev config
mkdir -p $HOME/.config/dev
ln -sf $DOTFILES/.config/dev/mysql.env $HOME/.config/dev/mysql.env
ln -sf $DOTFILES/.config/dev/docker-compose.yml $HOME/.config/dev/docker-compose.yml
ln -sf $DOTFILES/.config/dev/mysql-up.sh $HOME/.config/dev/mysql-up.sh

# SSH 키 (없을 때만 생성)
mkdir -p "$HOME/.ssh"
KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "${KEY}.pub" ]; then
  echo "[install] SSH key not found, generating new key..."
  ssh-keygen -t ed25519 -C "your.email@example.com" -f "$KEY" -N ""
  echo "[install] Public key generated:"
  cat "${KEY}.pub"
  echo "👉 위 키를 GitHub > Settings > SSH and GPG keys 에 등록하세요."
else
  echo "[install] Existing SSH key found, skipping generation."
fi
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/id_ed25519" 2>/dev/null || true
chmod 644 "$HOME/.ssh/id_ed25519.pub" 2>/dev/null || true

# git config
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global

echo "[install] done. Run 'source ~/.bashrc'"

