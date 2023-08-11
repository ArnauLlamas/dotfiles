#!/bin/zsh

echo "Installing Brew"
echo ""
echo ""

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install --cask font-sauce-code-pro-nerd-font

echo "Done!"
echo ""
echo ""

