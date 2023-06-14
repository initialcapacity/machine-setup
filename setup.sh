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
ssh=${5:-false}
personalize=${6:-false}

echo "Setting up $accountname on $machinename for $gituseremail ($gitname)..."

# optionally set up ssh key
if [ $ssh == true ]
then
	echo "Creating an SSH key for you..."
	ssh-keygen -t ed25519 -C "$gituseremail"
	pbcopy < ~/.ssh/id_ed25519.pub
	echo "\nThe public key has been added to your clipboard. \nAdd it to Github -> https://github.com/settings/ssh/new (cmd + double click) \n";
	read -p "Press [Enter] after adding SSH key to Github."
	echo "Authenticate to complete SSH setup."
	ssh -T git@github.com
	echo "";
fi

# turn off sudo password protection
echo "Turn off sudo password protection. We will turn it back on after the script finishes."
echo "Find this line at the bottom of the file: '%admin ALL = (ALL) ALL'"
echo "Using vi commands, add 'NOPASSWD:' so it reads '%admin ALL = (ALL) NOPASSWD: ALL'"
echo "':wq' to save and exit"
echo ""
read -p "Copy the directions you may need, then press [Enter]"
sudo visudo

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

# optionally grab dotfiles / personal preferences
if [ $personalize == true ]
then
	echo "Getting dotfiles from your GitHub account."
	read -p "Enter your git username: " username
	echo "Copying Personal Machine Preferences"
	git clone https://github.com/$username/dotfiles.git dotfiles
	echo "";
fi

# git
brew install git
git config --global user.email $gituseremail
git config --global user.name "$gitname"
git config --global init.defaultBranch main

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
brew install -q --cask --no-quarantine goland

# browsers
brew install -q --cask --no-quarantine firefox
brew install -q --cask --no-quarantine google-chrome

# Google Cloud
brew install -q --cask --no-quarantine google-cloud-sdk
echo 'source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"' >> ~/.zprofile
echo 'source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"' >> ~/.zprofile

# Heroku
brew tap heroku/brew && brew install heroku

# databases
brew tap homebrew/core
brew install -q postgresql@14
brew services start postgresql
brew install mysql

# other tools
brew install wget watch tree
brew install --cask --no-quarantine keepingyouawake jetbrains-toolbox slack zoom pop docker rectangle 1password iterm2
brew install --cask --no-quarantine pastebot krisp
brew install -q --cask --no-quarantine sublime-text
brew install -q --cask --no-quarantine intellij-idea
brew install -q --cask --no-quarantine rubymine
brew install -q flyway
brew install -q kubernetes-cli
brew install -q buildpacks/tap/pack
brew install -q gettext

source dotfiles/app_personalization.sh

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
mysides add workspace file:///Users/$accountname/workspace
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

source dotfiles/preferences.sh

mkdir ~/bin
echo "Adding local /bin to /etc/paths, may be prompted for root password"
sudo sh -c "echo /Users/$accountname/bin >> /etc/paths"

# turn sudo password protection back on
echo "Turn sudo password protection back on."
echo "Edit '%admin ALL = (ALL) NOPASSWD: ALL' to say '%admin ALL = (ALL) ALL'"
read -p "Copy the directions you may need, then press [Enter]"
sudo visudo

echo "****************************"
echo "$machinename setup complete!"
echo "Please restart your machine now"
echo "****************************"