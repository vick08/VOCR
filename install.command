#!/bin/bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew uninstall --force imagemagick
brew install --HEAD imagemagick
brew uninstall --force tesseract
brew install --HEAD tesseract
