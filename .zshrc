# Loading zinit
source ~/.zinit/bin/zinit.zsh
zinit light zsh-users/zsh-autosuggestions    # history suggestions
zinit light zsh-users/zsh-syntax-highlighting # live syntax coloring


# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/Gautam/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
# Starship init 
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml


# Other options
setopt autocd                  # just type dir name to cd into it
setopt correct                  # auto correct minor typing mistakes
setopt no_beep                  # no annoying terminal beep
setopt share_history            # share history across sessions
setopt inc_append_history       # write commands immediately to history
setopt extended_glob            # better wildcards like ls **/*.txt
# Case insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Tab completion menu
zstyle ':completion:*' menu select

# Make nvim the default editor 
export EDITOR=nvim
export VISUAL=nvim

# Config for zoxide
eval "$(zoxide init --cmd cd zsh)"

# Configuring pyenv for various python versions
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Configuring nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVM_LAZY_LOAD=true

# Aliases 
alias ll='ls -lah --color=auto'
alias l='ls -lh --color=auto'

# Add Scirpts alias 
alias git-submodule-sync="~/.dotfiles/.scripts/git-submodule-sync.sh"
