alias l='ls -lha'
alias s='git status'
alias t='tmux attach || tmux'

alias ..='cd ..'
alias ...='cd ../..'

# Fix beads socket for macOS bind mount
alias beads-link='mkdir -p /run/beads && ln -sf /run/beads/bd.sock /workspace/.beads/bd.sock'