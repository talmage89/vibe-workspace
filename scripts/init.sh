#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"
TARGET_DIR="$(pwd)"

if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "Error: Templates directory not found at $TEMPLATES_DIR"
    exit 1
fi

echo "Copying templates to $TARGET_DIR..."
cp -r "$TEMPLATES_DIR"/* "$TARGET_DIR/"

echo "Done! Templates copied successfully."
