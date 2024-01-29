echo "Running Personalized Script"

# List of apps to install
declare -a apps=( \
    1password-cli \
)

for package in "${apps[@]}"
do
  echo "Installing ${package}"
  brew install ${package}
done

brew tap microsoft/git

# List of trusted cask apps to install
declare -a caskApps=( \
    spotify \
    signal \
    dropbox \
    notion \
    nordvpn \
    todoist \
    postman \
    git-credential-manager \
    adobe-creative-cloud \
    warp
)

for package in "${caskApps[@]}"
do
  echo "Installing ${package}"
  brew install --cask --no-quarantine ${package}
done


# List of apps to remove
declare -a toRemove=( \
    
)

for package in "${toRemove[@]}"
do
  echo "Removing ${package}"
  brew uninstall ${package}
  brew autoremove
done
