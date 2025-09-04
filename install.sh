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

# git config
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global

echo "[install] done. Run 'source ~/.bashrc'"

