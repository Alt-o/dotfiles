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
# atuin comes from the nix profile (on PATH via env.zsh).
# `--disable-up-arrow`: plain up-arrow stays native history search;
# atuin search is invoked explicitly (see bindings.zsh for key bindings).
eval "$(atuin init zsh --disable-up-arrow)"

## --- fzf-tab (git submodule next to this file)
# Replaces the completion *selection menu* with fzf. Must load after
# compinit (done in completion.zsh) and before any plugin that wraps
# widgets (zsh-autosuggestions below).
source "$ZSHRC_DIR/fzf-tab/fzf-tab.plugin.zsh"
# Keep zsh's own menu off: fzf-tab needs to capture the candidates
# itself and hand them to fzf.
zstyle ':completion:*' menu no
# [group] labels in the fzf menu.
zstyle ':completion:*:descriptions' format '[%d]'
# [group] switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# Preview directory contents with eza when completing `cd`.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# Pop up window within tmux
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

## --- zsh-autosuggestions (git submodule next to this file)
source "$ZSHRC_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

## --- direnv: .envrc-managed environment per directory
eval "$(direnv hook zsh)"

## --- Fzf
# fzf-tab (above) owns the Tab menu, so source only fzf's key-binding
# script, not its full `--zsh` output (whose completion widget would
# rebind ^I). `fzf-share` prints the scripts directory — it works for
# the nix layout (share/fzf/) and the upstream one alike.
if [[ -r "$(fzf-share)/key-bindings.zsh" ]]; then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"
    source "$(fzf-share)/key-bindings.zsh"
fi
# fzf's key-bindings claim ^R for their plain zsh history search; atuin
# owns history here. Widgets live in the `widgets` hash, not `functions`
# (zsh-autosuggestions wraps them), so guard on `widgets`.
(( ${+widgets[atuin-search-viins]} )) &&
    bindkey -M viins '^R' atuin-search-viins
(( ${+widgets[atuin-search]} )) &&
    bindkey -M emacs '^R' atuin-search
# Resulting pickers: ^T file, Esc-c directory, ^R atuin, ^I fzf-tab
# menu.

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
