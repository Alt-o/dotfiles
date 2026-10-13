# ============================================================================
# completion.zsh — zsh completion setup.
#
# Must be sourced before any plugin that extends completion (fzf, atuin,
# zoxide, ...).
# ============================================================================

## --- Matching behaviour
# Case-insensitive completion: typing `Ls` completes to `ls`.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

## --- compinit
# Loads the completion system. Useful flags once it works:
#   compinit -C   skip the daily re-cache (faster startup; remember to
#                 rm ~/.zcompdump* after installing new completions)
#   compinit -u   skip the insecure-directory security scan
autoload -Uz compinit
compinit
