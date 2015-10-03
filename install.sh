#!/bin/sh

echo "Interactively linking dotfiles into ~..."
./link-dotfiles.sh

echo "Installing Vim packages..."
vim +PlugInstall +qa

echo "Disabling non-sandbox cabal installs..."
echo "require-sandbox: True" >> ~/.cabal/config

echo "If you like what you see in system/osx-settings, run ./system/osx-settings"
echo "If you're using Terminal.app, check out the terminal-themes directory"
