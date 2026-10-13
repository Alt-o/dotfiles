# ============================================================================
# completion.zsh — zsh completion setup.
#
# Must be sourced before any plugin that extends completion (fzf, atuin,
# zoxide, ...).
# ============================================================================

## --- Matching behaviour
# Case-insensitive completion: typing `Ls` completes to `ls`.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

## --- Colors
# Dracula palette for the completion menu (zsh list-colors spec). Used by
# plain compsys and by fzf-tab; eza gets its own EZA_COLORS (env.zsh).
zstyle ':completion:*' list-colors \
    'di=38;5;141:ln=38;5;117:ex=38;5;209:gi=38;5;241:ro=38;5;161' \
    '*.tar=38;5;161:*.tgz=38;5;161:*.zip=38;5;161:*.gz=38;5;161:*.7z=38;5;161'

## --- compinit
# Loads the completion system. Useful flags once it works:
#   compinit -C   skip the daily re-cache (faster startup; remember to
#                 rm ~/.zcompdump* after installing new completions)
#   compinit -u   skip the insecure-directory security scan
autoload -Uz compinit
compinit
