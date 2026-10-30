# ============================================================================
# functions.zsh — user-defined shell functions.
#
# One function per `##` block, with a one-line doc above it if it is
# non-obvious.
# ============================================================================

## --- clipcopy: copy a file's contents (or piped stdin) to the clipboard
# Port of oh-my-zsh's clipboard lib. Wayland uses wl-copy, X11 uses
# xclip. Usage: `clipcopy <file>` or `... | clipcopy`.
clipcopy() {
    local copy_cmd
    if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        copy_cmd="wl-copy"
    else
        copy_cmd="xclip -selection clipboard"
    fi
    if [[ $# -ge 1 ]]; then
        cat -- "$@" | eval "$copy_cmd"
    elif [[ -o interactive && -t 0 ]]; then
        # bare call at an interactive prompt: don't hang on stdin
        print "usage: clipcopy <file>  |  ... | clipcopy" >&2
        return 1
    else
        cat | eval "$copy_cmd"
    fi
}

## --- clippaste: print the clipboard to stdout
# `clippaste > file` writes it back to disk; in nvim use "+p with
# xclip instead.
clippaste() {
    if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        wl-paste
    else
        xclip -out -selection clipboard
    fi
}

## --- condash: lazy conda
# Activates conda in the current shell on demand, keeping shell startup
# fast. Call `condash` whenever a project needs the conda environment.
condash() {
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$(
        "$HOME/tools/anaconda3/bin/conda" 'shell.zsh' 'hook' \
            2> /dev/null
    )"
    if [[ $? -eq 0 ]]; then
        eval "$__conda_setup"
    elif [[ -f "$HOME/tools/anaconda3/etc/profile.d/conda.sh" ]]; then
        source "$HOME/tools/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/tools/anaconda3/bin:$PATH"
    fi
    unset __conda_setup
    # <<< conda initialize <<<
}
