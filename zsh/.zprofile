export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim +Man!"
export HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd:vim'

export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/lua-language-server/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
