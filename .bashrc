HISTFILE="$HOME/.bash_history"
HISTSIZE=50000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

set -o vi
export KEYTIMEOUT=1

parse_git_branch() {
  git branch 2>/dev/null | grep '*' | sed 's/* //'
}

PS1='\w $(parse_git_branch) $ '

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

bind '"\C-r": reverse-search-history'
bind '"\C-a": beginning-of-line'
bind '"\C-e": end-of-line'

alias ls='ls --color=auto'
alias la='ls -lA'
alias l='ls -lh'
alias v='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias src='source ~/.bashrc'
alias serve='python3 -m http.server 3000'

mkcd() { mkdir -p "$1" && cd "$1"; }
