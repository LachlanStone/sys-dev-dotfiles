# sys-dev-dotfiles (Chezmoi)

This repository now uses [chezmoi](https://www.chezmoi.io/) as the source-of-truth for dotfiles.

## Chezmoi-managed layout

- `dot_bashrc` -> `~/.bashrc`
- `dot_zshrc` -> `~/.zshrc`
- `dot_zshenv` -> `~/.zshenv`
- `dot_tmux.conf` -> `~/.tmux.conf`
- `dot_config/**` -> `~/.config/**`

Legacy folders (`bashrc/`, `zsh/`, `tmux/`, etc.) are kept for reference and ignored by chezmoi via `.chezmoiignore`.

## Install

1. Install chezmoi:

    ```sh
    sh -c "$(curl -fsLS get.chezmoi.io)"
    ```

2. Initialize from this repo:

    ```sh
    chezmoi init --apply lachlanstone
    ```

    Or for a local clone:

    ```sh
    chezmoi init --apply --source "$HOME/sys-dev-dotfiles"
    ```

## Day-to-day usage

- Apply latest state:

   ```sh
   chezmoi apply
   ```

- Edit a managed file:

   ```sh
   chezmoi edit ~/.zshrc
   ```

- See pending changes:

   ```sh
   chezmoi diff
   ```

- Add new file to chezmoi source state:

   ```sh
   chezmoi add ~/.config/<app>/<file>
   ```

## Notes

- `dotsetup.sh` is no longer required for normal setup.
- `dot_config/scripts/kube/executable_kubespace.sh` installs as `~/.config/scripts/kube/kubespace.sh` with executable permissions.
- `run_once_10-tenv-completions.sh` generates `tenv` completions on first apply when `tenv` is installed.
- Zsh now uses `zinit` (not Oh My Zsh). Update plugins with `zsh-update-plugins`.
- Prompt uses `starship`, configured in `~/.config/starship.toml` to show directory, git branch, and Kubernetes namespace.

---

**Author:** lachlanstone
**License:** MIT
