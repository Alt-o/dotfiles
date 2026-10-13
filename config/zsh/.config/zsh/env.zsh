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

## --- eza colors (Dracula, from draculatheme.com/eza)
# Keys are permission-bit classes: u*/g*/t* = user/group/other, suffix
# r=read w=write x=exec, da=directory, xx=unknown. eza colors its own
# output (ls is aliased to eza; tree via the lt alias), so no
# LS_COLORS is needed anywhere.
export EZA_COLORS="\
uu=36:\
uR=31:\
un=35:\
gu=37:\
da=2;34:\
ur=34:\
uw=95:\
ux=36:\
ue=36:\
gr=34:\
gw=35:\
gx=36:\
tr=34:\
tw=35:\
tx=36:\
xx=95:"

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
