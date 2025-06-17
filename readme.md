# sys-dev-dotfiles

A collection of my configuration files (dotfiles) and setup scripts for quickly configuring a my linux environment.

## Structure

- `dotsetup.sh` — Bash script to set up symlinks for config files.
- `bashrc/` — Bash shell configuration files.
- `zsh/` — Zsh shell configuration files.
- `tmux/` — Tmux configuration files.
- `btop/` — btop system monitor configuration.
- `tms/` — tms session manager config.
- `vim/` — Vim editor info/history.

## Usage

1. Clone this repository to your home directory.
2. Run the setup script:

   ```sh
   ./dotsetup.sh
   ```

3. The script will create symlinks and copy configuration files to the appropriate locations in your home directory and `.config`.

## Notes

- Some folders are excluded or handled specially (see `dotsetup.sh`).
- Edit the configs as needed for your environment.

---

**Author:** lachlanstone  
**License:** MIT (or specify your license)