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
# eza replaces ls: colored, git-aware, icons. The classic ls/oh-my-zsh
# aliases map onto it so muscle memory keeps working:
#   ls -> plain listing (eza default: icons + colors)
#   l  -> long, all files (ls -la)
#   ll -> long + human-readable sizes (ls -lh)
#   la -> all files, including dotfiles
#   lf -> plain listing with file-type markers (ls -lF)
#   lt -> 2-level tree with long info (tree)
alias ls='eza'
alias l='eza -l --icons --git -a'
alias ll='eza -lh --git'
alias la='eza -a --git'
alias lf='eza -F --git'
alias lt='eza --tree --level=2 --long --icons --git'
alias ltree='eza --tree --level=2 --icons --git'

## --- Misc
alias cat=bat
alias e='nvim'
alias python='python3'
alias sl='ls'  # classic typo catcher
alias src='cd ~/src'
