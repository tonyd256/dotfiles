#!/bin/sh

echo "Interactively linking dotfiles into ~..."
./link-dotfiles.sh

echo "Installing Vim packages..."
vim +PlugInstall +qa

echo "If you like what you see in system/osx-settings, run ./system/osx-settings"
