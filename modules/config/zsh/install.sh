#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -e $HOME/.zshrc ]; then
	ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc
fi

rm $HOME/.profile && ln -s $SCRIPT_DIR/.profile $HOME/.profile

if [ ! -e $HOME/.zprofile ]; then
	ln -s $SCRIPT_DIR/.zprofile $HOME/.zprofile
fi

mkdir -p $HOME/.zsh-scripts

if [ ! -e $HOME/.zsh-scripts/zsh-autosuggestions ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.zsh-scripts/zsh-autosuggestions"
fi

if [ ! -e $HOME/.zsh-scripts/zsh-syntax-highlighting ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-scripts/zsh-syntax-highlighting"
fi

if [ ! -e $HOME/.zsh-scripts/zsh-history-substring-search ]; then
	git clone https://github.com/zsh-users/zsh-history-substring-search.git "$HOME/.zsh-scripts/zsh-history-substring-search"
fi
