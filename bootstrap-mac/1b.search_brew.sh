#/bin/bash

export HOMEBREW_GITHUB_API_TOKEN=$(cat BREW_GITHUB_API_TOKEN)

brew search $@
