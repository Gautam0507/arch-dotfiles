#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Config for nvm 
source /usr/share/nvm/init-nvm.sh

# Config for zoxide
eval "$(zoxide init bash)"
