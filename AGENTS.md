# AGENTS.md

Conventions for working in this dotfiles repo. Keep this file free of
machine-specific paths or historical notes.

## Working rules

- Write code that follows current best practices and the latest
  applicable standards: clean, idiomatic, well-structured, and easy
  to maintain. Code must be human-readable and self-documenting:
  organized into small, well-separated blocks with comments where
  the intent is not obvious — never one dense wall of text.
- Commit messages: imperative subject (<=72 chars, no trailing
  dot), blank line, then the body as short bullet points — one
  change per line. Never a dense paragraph block.
- Never commit without explicit user approval: propose the file list
  and commit message, wait for the go-ahead.
- Small, reviewable changes; explain what/where/why; do not add
  features the user did not ask for.
- Update README in the same change as the behavior it describes.

## What this repo is

A stow-managed dotfiles repo. Workflow on any machine: `git clone` →
`make install`. Prerequisites: git + curl only (curl for the nix
installer); everything tool-like — including stow itself — comes from
the flake. `make install` must stay idempotent.

## Layout

- `config/` is the single stow root, target `$HOME`.
- One package per tool, mirroring the full target layout, e.g.
  `config/ghostty/.config/ghostty/config.ghostty` →
  `~/.config/ghostty/config.ghostty`. Stow strips the package dir
  name from the target path.
- `~/.zshrc` is a stow file (package `zsh`); zsh part files live in
  `~/.config/zsh/` (sourced via `ZSHRC_DIR`, load order: env,
  completion, plugins, bindings, aliases, functions, `.zshrc_local`).
- `.zshrc_local` pattern: live file gitignored, `.example` template
  committed, Makefile seeds with `cp --update=none`.
- Tool-generated dirs (e.g. `~/.config/ghostty/auto/`) stay on the
  machine; never stow or commit them.

## Tool ownership

- The flake (`buildEnv` package `dot-tools`) is the sole owner of
  tools. The tool list lives in exactly one place: the flake.
- `flake.lock` is always committed (pins the nixpkgs snapshot).
- Nix PATH setup lives in `config/zsh/.config/zsh/env.zsh`.

## Style

- 80 columns; 4-space indentation in zsh files; tabs only in the
  Makefile.
- One concern per file; blocks headed with `## ---`.

## State notes

- Submodules: `zsh-autosuggestions`, `fzf-tab` (under
  `config/zsh/.config/zsh/`).
- Palette is Dracula everywhere (ghostty theme, starship, eza,
  completion, tmux cursor). New colors must fit it.
- `~/.zsh_history` is never committed; history lives in atuin.
- `TODO.md` is machine-local and untracked.
