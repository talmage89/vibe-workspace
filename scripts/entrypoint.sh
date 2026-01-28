#!/bin/bash
set -e

# Start ssh-agent
eval "$(ssh-agent -s)" > /dev/null 2>&1

# Setup beads socket symlink to tmpfs (fixes chmod issue on macOS bind mounts)
mkdir -p /run/beads
if [ -d /workspace/.beads ] || [ -f /workspace/.beads/beads.db ]; then
    ln -sf /run/beads/bd.sock /workspace/.beads/bd.sock
fi

exec "$@"
