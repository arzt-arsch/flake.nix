# almost remove delay when entering/exiting vi mode
export KEYTIMEOUT=1

# if available use neovim with fhs
# if command -v fhs &> /dev/null
# then
#   function nvim-fhs ()
#   {
#     echo "nvim $@" | fhs
#   }
#   alias nvim="nvim-fhs"
#   export EDITOR="nvim-fhs"
# fi

# syntax highlighting
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# doing it here since value from .zshenv gets overwritten for some reason
export HISTFILE="$XDG_STATE_HOME/zsh/history"

source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/binds.zsh

# starship prompt
eval "$(starship init zsh)"
# zoxide
eval "$(zoxide init zsh)"

if command -v pfetch &> /dev/null
then
  pfetch
fi
