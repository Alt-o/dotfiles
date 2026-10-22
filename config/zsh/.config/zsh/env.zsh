# ============================================================================
# env.zsh — environment variables & PATH.
#
# Shared across machines. Machine-specific paths and values belong in
# .zshrc_local, not here.
# ============================================================================

## --- XDG
export XDG_CONFIG_HOME="$HOME/.config"

## --- Locale
# en_US.UTF-8 where the system ships it, otherwise C.UTF-8, which
# always exists (fresh WSL installs generate no other locales).
if locale -a 2>/dev/null | grep -qix 'en_US\.utf-\?8'; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
else
    export LANG=C.UTF-8
    export LC_ALL=C.UTF-8
fi

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

## --- WSL interop
# The PATH rebuild above drops the Windows paths WSL normally adds,
# so re-append them (powershell.exe & co. become reachable again).
# /mnt/c/Windows exists only on WSL; case-insensitive mounts make the
# mixed-case names resolve. Appended last so Linux tools always win.
if [[ -d /mnt/c/Windows ]]; then
    export PATH="$PATH:/mnt/c/Windows/system32:/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
fi

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
