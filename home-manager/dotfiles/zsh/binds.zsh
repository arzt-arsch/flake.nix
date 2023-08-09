zle -N edit_config
bindkey "^u" edit_config

zle -N prepend_sudo
bindkey -M vicmd s prepend_sudo
