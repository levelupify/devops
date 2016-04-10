#!/bin/bash

function brew_install_if_not_installed {
  package="${1}"
  shift
  curr="$(brew ls --versions ${package})"
  if [ "${curr}x" == "x" ]
  then
    brew install ${package} $*
  fi
}

function brew_cask_install_if_not_installed {
  appdir="${1}"
  package="${2}"
  if [ "${appdir}x" != "x" -a "${package}x" != "x" ]
  then
    shift
    curr="$(brew cask info ${package}) 2> /dev/null"
    if [ "${curr}x" == "x" ]
    then
      brew cask install --appdir="${appdir}" ${package} $*
    fi
  else
    echo "Unable to install cask, need to supply both APPDIR and PACKAGE NAME: "
  fi

}

# Ask for the administrator password upfront
# sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#################################
#             SYSTEM            #
#################################

# echo "------------------------------"
# echo "Installing Xcode Command Line Tools."
# Install Xcode command line tools
# xcode-select --install

# Install/upgrade nvm
echo "Installing/upgrading nvm..."
curl -so- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh 2>&1 /dev/null | bash 2>&1 /dev/null

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
echo "Upgrading Homebrew..."
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew_install_if_not_installed coreutils

# Install ruby-build and rbenv
#brew_install_if_not_installed ruby-build
#brew_install_if_not_installed rbenv
#LINE='eval "$(rbenv init -)"'
#grep -q "$LINE" ~/.extra || echo "$LINE" >> ~/.extra

# Install more recent versions of some OS X tools.
#brew_install_if_not_installed vim --override-system-vi
# brew_install_if_not_installed homebrew/dupes/grep
# brew_install_if_not_installed homebrew/dupes/openssh
# brew_install_if_not_installed homebrew/dupes/screen
#brew_install_if_not_installed homebrew/php/php55 --with-gmp

# Install font tools.
# brew tap bramstein/webfonttools
# brew_install_if_not_installed sfnt2woff
# brew_install_if_not_installed sfnt2woff-zopfli
# brew_install_if_not_installed woff2

# Install other useful binaries.
brew_install_if_not_installed ack
#brew_install_if_not_installed git
#brew_install_if_not_installed git-lfs
#brew_install_if_not_installed git-flow
#brew_install_if_not_installed git-extras
#brew_install_if_not_installed imagemagick --with-webp

# Install Cask
#brew tap caskroom/cask

# Core casks
#brew cask install --appdir="/Applications" alfred
# brew_cask_install_if_not_installed "~/Applications" iterm2
# brew_cask_install_if_not_installed "~/Applications" java

# # Development tool casks
# brew_cask_install_if_not_installed "/Applications" sublime-text3
# brew_cask_install_if_not_installed "/Applications" atom
# brew_cask_install_if_not_installed "/Applications" virtualbox
# brew_cask_install_if_not_installed "/Applications" vagrant

# # Misc casks
# brew_cask_install_if_not_installed "/Applications" google-chrome
# brew_cask_install_if_not_installed "/Applications" firefox
# brew_cask_install_if_not_installed "/Applications" slack

# Link cask apps to Alfred
#brew cask alfred link

# Install Docker, which requires virtualbox
#brew_install_if_not_installed docker
#brew_install_if_not_installed boot2docker

# Quick Look plugins for developers
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package 2> /dev/null


#################################
#       GENERAL DEV STUFF       #
#################################
brew_install_if_not_installed dnsmasq


#################################
#         WEB DEV STUFF         #
#################################

# Install nginx+php
brew_install_if_not_installed nginx
brew_install_if_not_installed php56

# Install Craft dependencies
brew_install_if_not_installed php56-mcrypt
brew_install_if_not_installed imagemagick

# Install data stores
brew_install_if_not_installed mysql
brew_install_if_not_installed postgresql
brew_install_if_not_installed redis
brew_install_if_not_installed elasticsearch

# Install node.js
brew_install_if_not_installed node


#################################
#             CLEANUP           #
#################################

# Remove outdated versions from the cellar.
brew cleanup

