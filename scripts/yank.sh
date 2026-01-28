#!/bin/bash
# Clipboard helper for nested tmux environments
# Sends OSC 52 wrapped in DCS passthrough to traverse outer tmux to terminal

buf=$(base64 | tr -d '\n')

# DCS passthrough format: \ePtmux;\e<escaped-OSC52>\e\\
# This passes through outer tmux layers to reach the terminal
printf '\033Ptmux;\033\033]52;c;%s\a\033\\' "$buf" > /dev/tty
