#!/bin/zsh

echo "Installing Alacritty"
echo ""
echo ""

brew install --cask alacritty

# Install catppuccin theme
git clone https://github.com/catppuccin/alacritty.git $HOME/.config/alacritty/catppuccin

echo "Done!"
echo ""
echo ""

