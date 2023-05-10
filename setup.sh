#!/usr/bin/env bash

if [ $# -lt 4 ]
  then
    echo
    echo "Usage: $0 machine_name account_name  git-user-email git-name"
    echo
    echo "Sets up new workstation"
    echo
    exit 1
fi

machinename=$1
accountname=$2
gituseremail=$3
gitname=$4

echo "Setting up $accountname on $machinename for $gituseremail ($gitname)..."

cat aliases >> ~/.aliases
cat bash_profile >> ~/.bash_profile
cat zshrc >> ~/.zshrc

# update machine name
sudo scutil --set HostName $machinename
sudo scutil --set LocalHostName $machinename
sudo scutil --set ComputerName $machinename

# update OS & tools
sudo softwareupdate --install-rosetta --agree-to-license
# Ignore: "Package Authoring Error: 012-51699: Package reference com.apple.pkg.RosettaUpdateAuto is missing installKBytes attribute"
xcode-select --install

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# brew
brew analytics off

# git
brew install git
git config --global user.email $gituseremail
git config --global user.name "$gitname"

# Java
brew install openjdk
brew tap -q AdoptOpenJDK/openjdk
brew install -q --cask adoptopenjdk11
echo 'export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home' >> ~/.zprofile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zprofile

# Ruby
brew install ruby-install chruby
echo "source /opt/homebrew/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source /opt/homebrew/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
ruby-install --latest ruby

# Go
brew install -q go
brew install -q --cask goland

# browsers
brew install -q --cask firefox
brew install -q --cask google-chrome

# Google Cloud
brew install -q --cask google-cloud-sdk
echo 'source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"' >> ~/.zprofile
echo 'source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"' >> ~/.zprofile

# Heroku
brew tap heroku/brew && brew install heroku

# databases
brew install -q postgresql@14
brew services start postgresql
brew install mysql

# other tools
brew install wget watch tree
brew install --cask keepingyouawake jetbrains-toolbox slack zoom pop docker rectangle 1password iterm2
brew install --cask pastebot krisp
brew install -q --cask sublime-text
brew install -q --cask intellij-idea
brew install -q --cask rubymine
brew install -q flyway
brew install -q kubernetes-cli
brew install -q buildpacks/tap/pack
brew install -q gettext

# set menu clock
defaults write com.apple.menuextra.clock "DateFormat" 'EEE MMM d  h:mm:ss a'
killall SystemUIServer

# stop Photos from opening automatically
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# remove apps from dock
defaults write com.apple.dock persistent-apps -array

# disable caps lock
# TODO

# disable sound effects
defaults write "Apple Global Domain" com.apple.sound.uiaudio.enabled -int 0

# set keyboard to use function keys
defaults write "Apple Global Domain" "com.apple.keyboard.fnState" -int 1

# enable key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -boolean false
# set keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
# set shorter delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# finder
# show full path in finder title bar
defaults write com.apple.finder '_FXShowPosixPathInTitle' -bool true
# finder opens to home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# allow finder to be closed with cmd-Q
defaults write com.apple.finder QuitMenuItem -bool true

# Add home and workstation to finder sidebar, remove others
brew install mysides 
mysides add $accountname file:///Users/$accountname
mysides add workstation file:///Users/$accountname/workstation
mysides remove Recents
mysides remove Applications
mysides remove Desktop
mysides remove Documents
mysides remove Downloads

# dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock largesize -int 512
defaults write com.apple.dock persistent-apps -array
killall Dock

# iTerm
# disable prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool true
# "import" settings
cp com.googlecode.iterm2.plist ~/Library/Preferences

mkdir ~/bin
echo "Adding local /bin to /etc/paths, may be prompted for root password"
sudo sh -c "echo /Users/$accountname/bin >> /etc/paths"

#install cloud-sql-proxy
curl -o ~/bin/cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.2.0/cloud-sql-proxy.darwin.amd64

#install pyenv and python 3.11
brew install pyenv
brew install python 3.11
pyenv global 3.11

#install poetry
curl -sSL https://install.python-poetry.org | python3 -

echo "****************************"
echo "$machinename setup complete!"
echo "Please restart now"
echo "****************************"
