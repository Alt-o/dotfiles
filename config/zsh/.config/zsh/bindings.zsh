# ============================================================================
# bindings.zsh — zle key bindings.
#
# Sourced after plugins.zsh: the autosuggest-* widgets must exist before
# they can be bound.
#
# Note: `^j` is the same byte as Enter, so it must never be rebound.
# ============================================================================

## --- Vi insert mode
# Home-row escape: `jj` leaves insert mode.
bindkey -M viins jj vi-cmd-mode

## --- Autosuggestions
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle

## --- Motion & history (arrow-key-free)
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
