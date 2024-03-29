#!/bin/zsh

# Install brew
zsh brew/install.sh

# Installs main dependencies
zsh install/install-deps-macos.sh

# Install other software one by one, in a very specific order
zsh oh-my-zsh/install.sh
zsh starship/install.sh
zsh asdf/install.sh
zsh alacritty/install.sh
zsh tmux/install.sh

# Creates links through links.prop files
./install/bootstrap.sh
