<img src="https://www.initialcapacity.io/images/logo-short.svg" height="50">

# Machine Setup for M-series Macs

This repo sets up a new computer Mac using a very lightweight bash script. It includes settings based on Initial Capacity's own usage. There are options to set up your own .dotfiles for additional apps and preferences on laptops.

## Prerequisites
1. Desired machine name
1. Desired account name and password
## Optional
1. A public Dotfiles repo in your personal GitHub account (github.com/githubusername/dotfiles.git) with:
   1. A list of apps you'd like to install named `app_preferences.sh` ([example](https://github.com/initialcapacity/machine-setup/dotfiles/example_app_preferences.sh))
   1. Any machine preferences named `machine_preferences.sh` ([example](https://github.com/initialcapacity/machine-setup/dotfiles/example_machine_preferences.sh))

## Start setup
1. Select language: English
1. Select country: United States
1. Skip accessibility
1. Select wifi network
1. Skip Migration Assistant (click `Not Now`)
1. Do not enter an Apple ID
1. Computer Account: Use desired machine password
1. Make This Your New Mac -> click Customize Settings
   1. Do not enable Location Services
   1. Do not share Analytics
1. Skip Screen Time
1. Disable Siri
1. Skip Touch ID
1. Select Light mode

## Automated steps
1. Access this [machine-setup README](https://github.com/initialcapacity/machine-setup) from your new machine for easier access
1. Download [machine-setup repo](https://github.com/initialcapacity/machine-setup)
   ```shell
   mkdir ~/workspace
   cd ~/workspace
   curl -L https://github.com/initialcapacity/machine-setup/archive/main.zip --output machine-setup.zip
   unzip machine-setup.zip
   cd machine-setup-main
   ```
1. Run setup script, pass in: machine name, account name (initialdev or other), github user email, and github name. If you'd like to create a new set of ssh keys and/or import your own preferences scripts, add true/false for arguments 5 and 6 (default = false).
   ```shell
    sh setup.sh <machine_name> <machine_user_name> <git_user_email> "<git_name>" <true/false> <true/false>
   ```

## Final steps
1. Change caps-lock to Control
   1. System Preferences -> Keyboard -> Keyboard Shortcuts -> Modifier Keys -> Change `Caps Lock` => `Control`
1. Jetbrains editor settings
   1. larger editor and console font
   1. Tab limit 4
   1. Disable parameter name hints
   1. Set up JDK
   1. Remove status bar and navigation bar