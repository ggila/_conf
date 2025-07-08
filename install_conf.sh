#!/bin/bash

ln -s ~/_conf/zshrc ~/.zshrc
ln -s ~/_conf/bashrc ~/.bashrc
ln -s ~/_conf/tmux.conf ~/.tmux.conf
ln -s ~/_conf/vimrc ~/.vimrc

if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
elif [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
fi
