#!/bin/bash
# --- 1. System Update & Prerequisites ---
echo "Updating system and installing DNF plugins..."
sudo dnf update -y
sudo dnf install -y dnf-plugins-core

# --- 2. Homebrew Setup (If not already installed) ---
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to path for the current session
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- 3. Install via Homebrew (Your Primary Choice) ---
echo "Installing apps via Brew..."
# Note: Zen and Parsec are often Casks on macOS, on Linux we check formulae or use official binaries
brew install ghostty spotify-tui spotifyd sonobus discord

# --- 4. Install via DNF (Secondary & System Tools) ---
echo "Installing system tools and requested DNF apps..."

# Draw.io (requested via DNF - typically requires the RPM or Flatpak, but checking repo)
sudo dnf install -y draw.io || echo "Draw.io not in DNF, consider: flatpak install flathub com.jgraph.drawio.desktop"

# Audio Mixer (The EarTrumpet alternative)
sudo dnf install -y volctl

# Parsec (Usually a .deb/.rpm download, but checking DNF)
sudo dnf install -y parsec || echo "Parsec may require manual RPM download from parsec.app"

# --- 5. Finalize Setup ---
echo "Installation complete!"
echo "--------------------------------------------------"
echo "AUDIO NOTE: Launch 'volctl' to see your new tray-based audio mixer."
echo "--------------------------------------------------"
