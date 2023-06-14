echo "Importing personal preferences from dotfiles"

# set screenshots location to ~/Desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# show all filename extensions in Finder by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Add folders to sidebar
mysides add Desktop
mysides add Downloads

# List of apps to open
declare -a apps=( \
    1Password \
    Rectangle \
    NordVPN \
    Notion \
    Slack \
    Pastebot \ 
)

for package in "${apps[@]}"
do
  echo "Installing ${package}"
  open ${package}.app
done

# add permanent dock items
defaults write com.apple.dock persistent-apps -array

defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/IntelliJ IDEA.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'


declare -a dockItems=( \
  Slack.app \
  Signal.app \
  Warp.app \
  Notion.app \
  Pop.app
)
for item in "${dockItems[@]}"
do
  defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>'Applications/$item'</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
done; killall Dock

mkdir ~/Dev