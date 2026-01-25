# Terminal settings for TUI applications (Claude Code, etc.)
export TERM=screen-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Ensure terminal size is properly reported
if [ -n "$TMUX" ]; then
    eval "$(resize)" 2>/dev/null || true
fi
