#!/bin/zsh

echo "Installing tmux"
echo ""
echo ""

if [[ "$(uname)" == "Darwin" ]]; then
  brew install tmux
else
  sudo apt install tmux
fi

echo "Done!"
echo ""
echo ""

