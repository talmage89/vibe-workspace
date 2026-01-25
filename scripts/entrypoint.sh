#!/bin/bash
set -e
eval "$(ssh-agent -s)" > /dev/null 2>&1
exec "$@"
