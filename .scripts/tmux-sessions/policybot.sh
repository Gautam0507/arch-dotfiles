#!/bin/bash

# Check if running inside a tmux session
if [ -z "$TMUX" ]; then
  # Start a new tmux session named 'policybot'
  tmux new-session -d -s policybot
  tmux attach-session -t policybot
  exit 0
fi

# Rename the current tmux session to 'policybot'
tmux rename-session -t "$(tmux display-message -p '#S')" "policybot"

# Set the base directory variable
BASE_DIR="/home/Gautam/Projects/cerai/policybot-frontend/policybot-frontend"

# Create the first window and open nvim
if [ "$(tmux display-message -p '#I')" -eq 1 ]; then
  tmux rename-window -t policybot:1 "editor"
  tmux send-keys -t policybot:1 "cd $BASE_DIR" C-m
  tmux send-keys -t policybot:1 "nvim" C-m
fi

# Create the second window for the server
tmux new-window -t policybot:2 -n "server"

# Split the second window into three panes (left, top-right, bottom-right)
tmux split-window -h -t policybot:2
sleep 0.5

# Switch to the right pane and split it horizontally
tmux select-pane -t policybot:2.2
tmux split-window -v -t policybot:2.2

# Add a 2-second delay to ensure tmux initializes all panes
sleep 2

# Configure the left pane for the backend
tmux select-pane -t policybot:2.1
tmux send-keys -t policybot:2.1 "cd $BASE_DIR/backend" C-m
sleep 0.5
tmux send-keys -t policybot:2.1 "source .venv/bin/activate" C-m
sleep 0.5
tmux send-keys -t policybot:2.1 "uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload" C-m

# Configure the top-right pane for the frontend
tmux select-pane -t policybot:2.2
tmux send-keys -t policybot:2.2 "cd $BASE_DIR/frontend" C-m
sleep 0.5
tmux send-keys -t policybot:2.2 "npm run dev" C-m

# Configure the bottom-right pane for Ollama serve
tmux select-pane -t policybot:2.3
tmux send-keys -t policybot:2.3 "cd $BASE_DIR" C-m
sleep 0.5
tmux send-keys -t policybot:2.3 "OLLAMA_HOST=0.0.0.0 ollama serve" C-m

# Adjust pane sizes
tmux resize-pane -t policybot:2.2 -y 20

# Switch back to the first window when done
tmux select-window -t policybot:1