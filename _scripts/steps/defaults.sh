#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/../utils.sh"

configure_defaults() {
	# Close any System Settings windows first
	osascript -e 'tell application "System Settings" to quit'

	# Ask for the admin password
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done 2>/dev/null &

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Sharing                                                                     #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# System Settings > General > Sharing > Local hostname
	COMPUTER_NAME="jabko-macbook"
	sudo scutil --set ComputerName "${COMPUTER_NAME}"
	sudo scutil --set HostName "${COMPUTER_NAME}"
	sudo scutil --set LocalHostName "${COMPUTER_NAME}"
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${COMPUTER_NAME}"

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Appearance                                                                  #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# System Settings > Appearance > Show scroll bars: Automatic
	defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

	# System Settings > Appearance > Click in the scrollbar to: Jump to the spot that's clicked
	defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

	# Disable the focus ring animation
	defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Sound                                                                       #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# Mute the chime sound on startup
	sudo nvram SystemAudioVolume=%80
	sudo nvram StartupMute=%01

	# Increase sound quality for Bluetooth devices
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" -int 80
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 80
	defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" -int 80
	defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" -int 80
	defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" -int 80
	defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" -int 80
	defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" -int 80

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Security                                                                    #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# System Settings > Network > Enable Firewall
	sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

	# System Settings > Network > Firewall > Options > Enable stealth mode
	sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1

	# Enable firewall logging
	sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -int 1

	# Enable secure virtual memory
	sudo defaults write /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap -bool true

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Dock                                                                        #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# System Settings > Desktop & Dock > Dock > Size
	defaults write com.apple.dock tilesize -int 52

	# System Settings > Desktop & Dock > Dock > Minimise windows into application icon
	defaults write com.apple.dock minimize-to-application -bool true

	# System Settings > Desktop & Dock > Dock > Minimise windows using: Scale
	defaults write com.apple.dock mineffect -string "scale"

	# System Settings > Desktop & Dock > Dock > Show recent applications in Dock
	defaults write com.apple.dock show-recents -bool false

	# System Settings > Desktop & Dock > Hot corners
	defaults write com.apple.dock wvous-tl-corner -int 0
	defaults write com.apple.dock wvous-tl-modifier -int 0

	defaults write com.apple.dock wvous-tr-corner -int 0
	defaults write com.apple.dock wvous-tr-modifier -int 0

	defaults write com.apple.dock wvous-bl-corner -int 0
	defaults write com.apple.dock wvous-bl-modifier -int 0

	defaults write com.apple.dock wvous-br-corner -int 0
	defaults write com.apple.dock wvous-br-modifier -int 0

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Screen                                                                      #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# System Settings > Desktop & Screen Saver > Start after: Never
	defaults -currentHost write com.apple.screensaver idleTime -int 0

	# System Settings > Lock Screen > Turn display off on power adapter when inactive
	sudo pmset -c displaysleep 15

	# System Settings > Lock Screen > Turn display off on battery when inactive
	sudo pmset -b displaysleep 5

	# Turn on automatic reset on power loss
	sudo pmset -a autorestart 1

	# Change screenshots location
 	# defaults write com.apple.screencapture location -string "${HOME}/screenshots"

	# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"

	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Input                                                                       #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# System Settings > Trackpad > Tap to click
	defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write 'Apple Global Domain' com.apple.mouse.tapBehavior 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

	# Disable press-and-hold for special keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

	# System Settings > Keyboard > Key repeat rate
	defaults write NSGlobalDomain KeyRepeat -int 2

	# System Settings > Keyboard > Delay until repeat
	defaults write NSGlobalDomain InitialKeyRepeat -int 15

	# System Settings > Keyboard > Keyboard navigation
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

	# System Settings > Keyboard > Text input > Correct spelling automatically: Disabled
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	# System Settings > Keyboard > Text input > Capitalise words automatically: Disabled
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

	# System Settings > Keyboard > Text input > Add full stop with double-space: Disabled
	defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

	# System Settings > Keyboard > Text input > Use smart dashes: Disabled
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

	# System Settings > Keyboard > Text input > Use smart quotes: Disabled
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

	# System Settings > Keyboard > Keyboard Shortcuts > App Shortcuts > All Applications > Zoom
	defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Zoom" -string '@$^~f'

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Apple Intelligence                                                          #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# System Settings > Apple Intelligence & Siri > Apple Intelligence: Disabled
	defaults write com.apple.CloudSubscriptionFeatures.optIn "device" -bool "false"
 	defaults write com.apple.CloudSubscriptionFeatures.optIn "auto_opt_in" -bool "false"

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Finder                                                                      #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# Finder > General > New Finder windows show: $HOME
	# For other paths, use `PfLo` and `file:///full/path/here/`
	defaults write com.apple.finder NewWindowTarget -string "PfLo"
	defaults write com.apple.finder NewWindowTargetPath -string "file:///${HOME}/"

	# Finder > Preferences > Show all filename extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	# Finder > Preferences > Show warning before changing an extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

	# Finder > Preferences > Keep folders on top: In windows when sorting by name
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	# Finder > Preferences > When performing a search: Search the Current Folder
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

	# Finder > View > As List
	defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

	# Finder > View > Show Path Bar
	defaults write com.apple.finder ShowPathbar -bool true

	# Finder > View > Show Status Bar
	defaults write com.apple.finder ShowStatusBar -bool true

	# Show hidden files by default
	defaults write com.apple.finder AppleShowAllFiles -bool true

	# Disable window animations and Get Info animations
	defaults write com.apple.finder DisableAllAnimations -bool true

	# Disable creating .DS_Store files on network or USB volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	# Enable AirDrop over Ethernet and on unsupported Macs running Lion
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

	# Show the ~/Library folder
	sudo chflags nohidden ~/Library

	# Show the /Volumes folder
	sudo chflags nohidden /Volumes

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
	# Desktops                                                                    #
	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# Create desktops
	osascript -e 'do shell script "open -b 'com.apple.exposelauncher'"
	delay 0.5
	tell application id "com.apple.systemevents"
		tell (every application process whose bundle identifier = "com.apple.dock")
			set countSpaces to count buttons of list 1 of group 2 of group 1 of group 1
			repeat until countSpaces = 10
				click (button 1 of group 2 of group 1 of group 1)
				set countSpaces to countSpaces + 1
			end repeat
		end tell
		delay 0.5
		key code 53 -- esc key
	end tell'

	# Enable "Switch to Desktop x" keyboard shortcut for each desktop
	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 118 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>18</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 119 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>19</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 120 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>20</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 121 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>21</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 122 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>23</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 123 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>22</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 124 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>26</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 125 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>28</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 126 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>25</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 127 "
	  <dict>
	    <key>enabled</key><true/>
	    <key>value</key><dict>
	      <key>type</key><string>standard</string>
	      <key>parameters</key>
	      <array>
	        <integer>65535</integer>
	        <integer>29</integer>
	        <integer>262144</integer>
	      </array>
	    </dict>
	  </dict>
	"

	/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

	# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# Kill affected applications
	for app in "cfprefsd" \
		"Dock" \
		"Finder" \
		"SystemUIServer"; do
		killall "${app}" 2>/dev/null || true
	done
}

failed=0
(
	title "Configuring MacOS defaults"

	configure_defaults
) || failed=1

if [ $failed -eq 0 ]; then
	ok "MacOS configured successfully!"
else
	err_exit "One or more errors occured during MacOS defaults configuration. Try running defaults.sh again."
fi
