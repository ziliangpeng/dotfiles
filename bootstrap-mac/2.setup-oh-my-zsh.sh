#!/bin/bash

cd ~
echo "Installing oh-my-zsh... -----------------------"
# Step-by-step install
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/oh-my-zsh #conflict if repo already pulled

echo "Setting up .zshrc -----------------------------"
rm ~/.zshrc
ln -s $HOME/dotfiles/zsh/zshrc $HOME/.zshrc

if [ "/bin/zsh" != $SHELL ]; then
  echo "Change shell ----------------------------------"
  chsh -s /bin/zsh
fi


