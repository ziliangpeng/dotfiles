#!/bin/bash

cd ~
echo "Removing old ~/.oh-my-zsh ---------------------"
rm -rf .oh-my-zsh
rm -rf ~/.oh-my-zsh-custom

echo "Installing oh-my-zsh... -----------------------"
# Manually install
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
echo "Installing customs -------------------------------"
git clone --recursive git@git.musta.ch:victor-peng/vpzsh.git .oh-my-zsh-custom

echo "Setting up .zshrc -----------------------------"
rm ~/.zshrc
ln -s $HOME/Dropbox/config/oh-my-zsh-config/.zshrc $HOME/.zshrc

echo "Putting submodule back to master branch -------"
cd ~/.oh-my-zsh-custom
git submodule foreach git checkout master



if [ "/bin/zsh" != $SHELL ]; then
  echo "Change shell ----------------------------------"
  chsh -s /bin/zsh
fi


