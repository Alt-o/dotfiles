# ============================================================================
# plugins.zsh — plugin initializers.
#
# Order matters:
#   - completion.zsh already ran (compinit is a prerequisite for several
#     of these).
#   - atuin and zoxide hook into history/directory-change handling.
#   - starship comes last: nothing after it may touch the prompt.
# ============================================================================

## --- Atuin: synced, searchable shell history
# The installer drops a bin/env file that puts atuin's shims on PATH;
# it must be loaded before `atuin init`.
[[ -f "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"
# `--disable-up-arrow`: plain up-arrow stays native history search;
# atuin search is invoked explicitly (see bindings.zsh for key bindings).
eval "$(atuin init zsh --disable-up-arrow)"

## --- zsh-autosuggestions (git submodule next to this file)
source "$ZSHRC_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

## --- Nix
# User-level config dir (stowed nix/nix.conf).
export NIX_CONF_DIR="$XDG_CONFIG_HOME/nix"
# Multi-user setup: nix-daemon.sh puts the system nix profile on PATH
# (this is where the nix binary itself lives).
if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
# Per-user nix profile: where `nix profile add` installs tools (the
# dotfiles flake). Prepend so these win over distro packages.
if [[ -e "$HOME/.nix-profile/bin" ]]; then
    export PATH="$HOME/.nix-profile/bin:$PATH"
fi
# System-wide nix profile; only non-empty on NixOS or nix-env installs.
if [[ -d /nix/var/nix/profiles/default/bin ]]; then
    export PATH="/nix/var/nix/profiles/default/bin:$PATH"
fi

## --- direnv: .envrc-managed environment per directory
eval "$(direnv hook zsh)"

## --- Fzf: ^T file / ^C directory / ^B process pickers
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"
source <(fzf --zsh)

## --- pnpm (better npm)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME/bin:"*) ;;
    *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

## --- Zoxide: smarter cd (`z <query>`)
eval "$(zoxide init zsh)"

## --- Mise: language version managers (go, node, ...)
# Adds the mise shims; guard so shells without mise still start cleanly.
command -v mise > /dev/null && eval "$(mise activate zsh)"

## --- Starship: cross-shell prompt (keep last)
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"
