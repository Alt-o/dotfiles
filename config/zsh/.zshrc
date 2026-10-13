# ============================================================================
# .zshrc — entry point for interactive zsh shells.
#
# Stowed to the home root (~/.zshrc) by stow, with target $HOME
# (see the Makefile). The part files below live in ~/.config/zshrc/,
# stowed by the nested stow root at zshrc/.config/.
#
# Parts, in load order:
#   env.zsh        environment variables & PATH
#   completion.zsh compinit + completion behaviour
#   plugins.zsh    plugin initializers (order-sensitive)
#   bindings.zsh   key bindings (needs plugins loaded first)
#   aliases.zsh    aliases
#   functions.zsh  user-defined functions
#   .zshrc_local   per-machine extras (optional)
# ============================================================================

ZSHRC_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

source "$ZSHRC_DIR/env.zsh"
source "$ZSHRC_DIR/completion.zsh"
source "$ZSHRC_DIR/plugins.zsh"
source "$ZSHRC_DIR/bindings.zsh"
source "$ZSHRC_DIR/aliases.zsh"
source "$ZSHRC_DIR/functions.zsh"

## --- Per-machine extras (optional)
[[ -f "$ZSHRC_DIR/.zshrc_local" ]] && source "$ZSHRC_DIR/.zshrc_local"
