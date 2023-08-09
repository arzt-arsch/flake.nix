export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export EDITOR="nvim"
export BROWSER="firefox"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export ANDROID_HOME="$XDG_DATA_HOME/android"
# export FZF_DEFAULT_COMMAND="rg -uu --files --glob !**/.git/* --glob !**target/*"
export FZF_DEFAULT_COMMAND="rg -uu --files --glob \!\*\*/.git/\*"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export XCOMPOSECACHE="${XDG_CACHE_HOME}"/X11/xcompose
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"

export PATH="$XDG_DATA_HOME/cargo/bin/:$PATH"
export PATH="$XDG_CONFIG_HOME/bin:$PATH"
