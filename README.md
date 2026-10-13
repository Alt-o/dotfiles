# dotfiles

My dotfiles synced from localhost and remote machines.

## Install

```
git clone <this repo> && cd dotfiles
make install
```

`make install` runs, in order:

1. `install-deps` — `stow` + Nerd Fonts
2. `install-nix` — nix then the tool set from `flake.nix` via
   `nix profile add .`
3. `install-dotfiles` — submodules, `stow -R`, and a
   `.zshrc_local` seed

Everything tool-like comes from the flake.

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
config/tmux/.tmux.conf           -> ~/.tmux.conf
```

The Makefile runs `stow -R` (every top-level dir is a package) and
seeds `.zshrc_local`.
