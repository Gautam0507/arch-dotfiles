#!/bin/bash
# fix_zsh_history.sh
# Script to repair a corrupted Zsh history file

HISTFILE="$HOME/.histfile"
BACKUP="${HISTFILE}_bad"

# Step 1: Backup the corrupted history file
if [[ -f "$HISTFILE" ]]; then
    mv "$HISTFILE" "$BACKUP"
    echo "Backed up corrupted history to $BACKUP"
else
    echo "No ~/.zsh_history file found!"
    exit 1
fi

# Step 2: Extract readable entries into a new history file
if command -v strings &>/dev/null; then
    strings "$BACKUP" > "$HISTFILE"
    echo "Extracted clean history"
else
    echo "Error: 'strings' command not found. Install binutils."
    exit 1
fi

# Step 3: Reload history into current shell
if [[ -n "$ZSH_VERSION" ]]; then
    fc -R "$HISTFILE"
    echo "History reloaded in current Zsh session."
else
    echo "Not running inside Zsh. History file rebuilt but not reloaded."
fi

# Step 4: Ask user before deleting backup
read -p "Delete backup $BACKUP? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm "$BACKUP"
    echo "Backup deleted."
else
    echo "Backup kept."
fi

echo "Done."

