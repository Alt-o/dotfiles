# ============================================================================
# aliases.zsh — aliases.
#
# Convention: short prefix per tool family (git = g*, docker = d*, ...).
# ============================================================================

## --- Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

## --- eza (modern ls)
alias l='eza -l --icons --git -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias ltree='eza --tree --level=2 --icons --git'

## --- Misc
alias cat=bat
alias e='nvim'
alias python='python3'
alias sl='ls'  # classic typo catcher
alias src='cd ~/src'
alias tree='tree -C'
