# dotfiles

My dotfiles synced from localhost and remote machines.

## Install

```
git clone <this repo> && cd dotfiles
make install
```

`make install` runs, in order:

1. `install-deps` — Nerd Fonts (curl installer)
2. `install-nix` — nix then the tool set from `flake.nix` via
   `nix profile add .`
3. `install-dotfiles` — submodules, `stow`, tmux plugins
   (via TPM), and a `.zshrc_local` seed

Everything tool-like — including stow itself — comes from the flake.

## Layout

```
config/<tool>/   one stow package per tool, mirroring the tool's
                 full target layout: home dotfiles AND XDG subdirs
```

One stow root (`config/`), one target (`$HOME`): stow strips the
package dir from the link path and creates intermediate dirs, so

```
config/zsh/.zshrc                -> ~/.zshrc
config/zsh/.config/zsh/*.zsh     -> ~/.config/zsh/*.zsh
config/starship/.config/…        -> ~/.config/starship/…
config/ghostty/.config/…         -> ~/.config/ghostty/…
```

The Makefile runs `stow *` (every top-level dir is a package),
installs the tmux plugins with TPM, and seeds `.zshrc_local`.

Machine/personal values never live in the repo: they go in
`_local` files next to the stowed config (`~/.zshrc_local`,
`~/.gitconfig_local`), included by the stowed file and created
per host.
