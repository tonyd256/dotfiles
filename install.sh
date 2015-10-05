#!/bin/sh

echo "Interactively linking dotfiles into ~..."
./link-dotfiles.sh

echo "Installing Vim packages..."
vim +PlugInstall +qa

echo "Installing Xcode theme..."
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes/
cp xcode/themes/Solarized\ -\ Dark.dvtcolortheme ~/Library/Developer/Xcode/UserData/FontAndColorThemes/

echo "If you like what you see in system/osx-settings, run ./system/osx-settings"
echo "If you're using Terminal.app, check out the terminal-themes directory"
