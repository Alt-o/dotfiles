# ============================================================================
# env.zsh — environment variables & PATH.
#
# Shared across machines. Machine-specific paths and values belong in
# .zshrc_local, not here.
# ============================================================================

## --- XDG
export XDG_CONFIG_HOME="$HOME/.config"

## --- Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

## --- Editors
export EDITOR=nvim

## --- Go
export GOPATH="$HOME/go"

## --- Tool flags
export CLICOLOR=1            # force colored ls
export BUILD_COLORS=1        # force colored build output
export GLAB_FORCE_COLOR=1    # force colored glab output
export ZLE_RPROMPT_INDENT=0  # starship right-prompt alignment

## --- PATH
export PATH="/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin"
export PATH="/usr/lib64/ccache:$PATH"
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"  # opencode agent
