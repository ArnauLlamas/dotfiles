#!/bin/zsh

echo "Installing generic dependencies and software"
echo ""
echo ""

brew install --cask font-sauce-code-pro-nerd-font
brew install --cask rectangle
brew install obsidian
brew install gomplate

brew install docker
brew install docker-compose

brew install trash
brew install tree
brew install jsonpp
brew install wget
brew install git
brew install neofetch

brew install eza
brew install bat
brew install ripgrep
brew install vim
brew install gsed

# Note: jq, neovim, terraform, node, uv, tflint, trivy, terraform-docs, usage
# are managed by mise (mise/config.toml). Do not add them here.

echo "Done!"
echo ""
echo ""

