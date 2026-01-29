HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS

setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS

bindkey -v
export KEYTIMEOUT=1

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'

setopt PROMPT_SUBST
PS1='%B%F{green}%n@btw%f%b:%F{blue}%c%f${vcs_info_msg_0_} %F{white}$%f '

autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

alias ls='ls --color=auto'
alias la='ls -lA'
alias l='ls -lh'
alias ll='l -A'
alias rmr='rm -rf'

alias v='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias src='source $ZDOTDIR/.zshrc'

alias serve='python3 -m http.server 3000'

mkcd() { mkdir -p $1 && cd $1; }
