#!/bin/zsh

echo "Installing Alacritty"
echo ""
echo ""

brew install --cask alacritty

# We use Alacritty's default Linux config directory as our storage location here.
mkdir -p $HOME/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme $HOME/.config/alacritty/themes

echo "Done!"
echo ""
echo ""

