#!/bin/bash

# Install xcode command line tool
xcode-select --install

# Install homebrew
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install Cask
brew tap caskroom/cask

brew update
brew tap homebrew/bundle

