echo "Importing personal app preferences from dotfiles"

# List of apps to install
declare -a apps=( \
    1password-cli \
)

for package in "${apps[@]}"
do
  echo "Installing ${package}"
  brew install ${package}
done

# List of trusted cask apps to install
declare -a caskApps=( \
    spotify \
    signal \
    notion \
    nordvpn \
    warp
)

for package in "${caskApps[@]}"
do
  echo "Installing ${package}"
  brew install --cask --no-quarantine ${package}
done


# List of apps to remove
declare -a toRemove=( \
    sublime-text \
)

for package in "${toRemove[@]}"
do
  echo "Removing ${package}"
  brew uninstall ${package}
  brew autoremove
done