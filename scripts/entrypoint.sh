#!/bin/bash
set -e
eval "$(ssh-agent -s)" > /dev/null 2>&1
sudo chown -R claude:claude /workspace/.beads
exec "$@"
