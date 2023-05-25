#!/bin/bash

# Install xcode command line tool
xcode-select --install

# Install homebrew
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install Cask
# NOTE(20230524): cask is already part of brew, no need to install.
# If you run `brew install cask`, it will install a emacs package management tool, which is not Cask.
# brew tap caskroom/cask

brew update
brew tap homebrew/bundle

