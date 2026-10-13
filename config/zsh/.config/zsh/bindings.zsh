# ============================================================================
# bindings.zsh — zle key bindings.
#
# Sourced after plugins.zsh: the autosuggest-* widgets must exist before
# they can be bound.
#
# Note: `^j` is the same byte as Enter, so it must never be rebound.
# ============================================================================

## --- Vi mode
# `set -o vi` switches zle to the vi keymaps and auto-insert: after each
# command the shell starts in viinsert. `bindkey -L` shows the mode:
#   ^  insert mode (type commands)
#   #  command mode (hjkl to move, backspace to delete, Enter to run)
# Home-row escape: `jj` leaves insert mode, just like in vim.
set -o vi
bindkey -M viins jj vi-cmd-mode

## --- Autosuggestions
bindkey '^f' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle

## --- Motion & history (arrow-key-free)
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
