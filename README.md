# dots

A space for my Mac's dotfiles. It also includes few scripts to automate most of my setup from scratch.

## Installation

**Prerequisites**: Give a terminal application additional permissions:
- `System Settings -> Privacy & Security -> Full Disk Access`
- `System Settings -> Privacy & Security -> Accessibility`
- `System Settings -> Privacy & Security -> Automation -> System Events`
	- Can be done by running, e.g. `osascript -e 'tell application "System Events" to keystroke "."'`, but `install.sh` script already handles that 

Use `run.sh` script to copy the repository and run full installation:

`/bin/bash -c "$(curl -L https://raw.githubusercontent.com/jabkoo/dots/main/run.sh)"`

or use `_scripts/install.sh` to run the installation if the repository was already cloned.

Both scripts accept following options:
- `-h, --help`: Displays help message
- `-o, --only`: Executes only specified scripts
- `-e, --except`: Exclude specified scripts from running

Available scripts:
- `dirs`: Creates necessary directories
- `softwareupdate`: Runs MacOS software update and installs Rosetta
- `homebrew`: Installs Homebrew package manager and packages defined in Brewfile
- `stow`: Stows packages
- `ssh`: Generates a new SSH key
- `firefox`: Configures Firefox browser"
- `xcode`: Builds XCode
- `defaults`: Configures various default MacOS settings
