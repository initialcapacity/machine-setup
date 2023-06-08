<img src="https://www.initialcapacity.io/images/logo-short.svg" height="50">

# Machine Setup for M-series Macs

This repo sets up a new computer Mac using a very lightweight bash script. There are no options (yet) and it includes settings based on Initial Capacity's own usage.

## Prerequisites
1. Apple ID and password
1. Desired machine name
1. Desired account name and password

## Start setup
1. Select language: English
1. Select country: United States
1. Skip accessibility
1. Select wifi network
1. Skip Migration Assistant (click `Not Now`)
1. Sign in with your Apple ID
1. Computer Account: Use desired machine password
   1. Allow icloud to unlock
1. Skip iCloud keychain setup
1. Make This Your New Mac -> click Customize Settings
   1. Do not enable Location Services
   1. Do not share Analytics
1. Skip Screen Time
1. Disable Siri
1. FileVault Disk Encryption 
   1. Turn on FileVault disk encryption 
   1. Allow my iCloud account to unlock my disk
1. Skip Touch ID
1. Skip Apple Pay (Click `Add this card later`)
1. Select Light mode

## Automated steps
1. Access this [machine-setup README](https://github.com/initialcapacity/machine-setup) from your new machine for easier access
1. [Create new SSH keys for Github access](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
1. Install homebrew
   ```shell
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
   eval "$(/usr/local/bin/brew shellenv)"
   ```
1. Git clone [machine-setup repo](https://github.com/initialcapacity/machine-setup)
   ```shell
   mkdir ~/workspace
   cd ~/workstation
   git clone https://github.com/initialcapacity/machine-setup.git
   ```
1. Run setup script, pass in: machine name, account name (initialdev or other), github user email, and github name
   ```shell
    cd ~/workstation/machine-setup
    ./setup.sh <machine_name> <machine_user_name> <git-user-email> "<git-name>"
   ```
   
## Final steps
1. Change caps-lock to Control
   1. System Preferences -> Keyboard -> Modifier Keys -> Change `Caps Lock` => `Control`
1. Jetbrains editor settings
   1. larger editor and console font
   1. Tab limit 4
   1. Disable parameter name hints
   1. Set up JDK
   1. Remove status bar and navigation bar
