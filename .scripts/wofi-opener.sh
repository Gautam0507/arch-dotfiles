#!/bin/bash

# Grep all files (change '.' to your base directory if needed)
file=$(rg --files . | wofi --dmenu --prompt "Open file:")

# Check if a file was selected
[ -n "$file" ] && xdg-open "$file"

