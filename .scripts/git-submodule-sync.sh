#!/bin/bash

# Sync the submodule configuration
git submodule sync

# Update the submodules recursively
git submodule update --init --recursive

# Pull the latest changes from the submodule's master branch (or modify as needed)
git submodule foreach git pull origin main
