#!/bin/bash

export HOMEBREW_GITHUB_API_TOKEN=$(cat BREW_GITHUB_API_TOKEN)
brew update

cat BREW_APPS | xargs -n 1 brew install

cat CASK_APPS | xargs -n 1 brew install
