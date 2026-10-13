# ============================================================================
# functions.zsh — user-defined shell functions.
#
# One function per `##` block, with a one-line doc above it if it is
# non-obvious.
# ============================================================================

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
