#!/bin/zsh

echo "Installing ASDF"
echo ""
echo ""

brew install asdf
source /opt/homebrew/opt/asdf/libexec/asdf.sh

# Add plugins that are in .tool-versions file
while read line
do 
  plugin=$(echo $line | cut -d' ' -f1)
  asdf plugin add $plugin
done < <(cat $DOTFILES/asdf/.tool-versions)

asdf install

echo "Done!"
echo ""
echo ""

