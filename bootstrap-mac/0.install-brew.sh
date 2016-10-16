#!/bin/bash

# Install xcode command line tool
xcode-select --install

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Cask
brew tap caskroom/cask

brew update
brew tap homebrew/bundle

