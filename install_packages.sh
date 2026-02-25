#!/usr/bin/env bash
set -euo pipefail

echo "Installing required DNF packages"
sudo dnf install -y \
	git \
	curl \
	zsh \
	direnv \
	fzf \
	tmux \
	btop \
	htop \
    bat \
    ripgrep \
    jq \
    shutter \
    bc

echo "Installing additional DNF packages used for utlity reasons"
sudo dnf install -y \
    wireguard-tools \
    nmap \
    lftp \
    rsync

echo "Installing additional DNF packages used by your dev workflow"
sudo dnf install -y \
	docker-cli \
	containerd \
	docker-compose \
	docker-compose-switch \
	qemu-user-static \
	gcc \
	clang \
    libguestfs-tools \
	httpd-tools \
	openssl \
	openssh-clients \
	nvim \
	zoxide

sudo dnf group install -y development-tools

if ! command -v brew >/dev/null 2>&1; then
	echo "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Load brew into current shell (Linuxbrew path first, fallback to generic)
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
	eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
elif command -v brew >/dev/null 2>&1; then
	eval "$(brew shellenv)"
fi

echo "Installing brew packages required by your zsh/cli config"
for pkg in kubernetes-cli lazygit thefuck chezmoi starship gh; do
	if ! brew list --formula "$pkg" >/dev/null 2>&1; then
		brew install "$pkg"
	else
		echo "$pkg already installed, skipping"
	fi
done
mkdir -p "$HOME/.local/share/chezmoi"

if command -v brew >/dev/null 2>&1; then
	echo "Installing brew packages for your Kubernetes workflow"
	for pkg in talosctl k9s helm fluxcd/tap/flux dgunzy/tap/flux9s tealdeer; do
		if ! brew list --formula "$pkg" >/dev/null 2>&1; then
			brew install "$pkg"
		else
			echo "$pkg already installed, skipping"
		fi
	done

	echo "Installing tenv (optional but recommended for completion generation)"
	# skip if already present either in PATH or as a brewed formula
	if command -v tenv >/dev/null 2>&1 || \
		brew list --formula tofuutils/tap/tenv >/dev/null 2>&1; then
		echo "tenv already installed, skipping"
	else
		if brew tap tofuutils/tap >/dev/null 2>&1; then
			brew install tofuutils/tap/tenv || true
			echo "Installing latest OpenTofu and Terraform via tenv"
			if command -v tenv >/dev/null 2>&1; then
				tenv tofu install latest
				tenv tf install latest
			elif [ -x "$(brew --prefix)/bin/tenv" ]; then
				"$(brew --prefix)/bin/tenv" tofu install latest
				"$(brew --prefix)/bin/tenv" tf install latest
			else
				echo "tenv was not found in PATH after install; run manually: tenv tofu install latest && tenv tf install latest"
			fi
		else
			echo "Could not tap tofuutils/tap automatically; install tenv manually if needed."
		fi
	fi
	echo "Updating Homebrew"
	brew update || true
	brew upgrade || true
fi

echo "Install rustup/cargo if missing (needed by ~/.zshenv)"
if [ ! -f "$HOME/.cargo/env" ]; then
	curl https://sh.rustup.rs -sSf | sh -s -- -y
fi

echo "Done. Restart shell or run: source ~/.zshrc"
