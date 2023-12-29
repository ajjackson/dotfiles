#! /usr/bin/env bash
source /usr/local/bin/_entrypoint.sh
cd "$HOME/src/dotfiles" || exit
PATH="$HOME/.local/bin:$PATH" ./make.el
rm ~/.bashrc
stow --dotfiles --target $HOME emacs bash fish git ssh tmux
bash
