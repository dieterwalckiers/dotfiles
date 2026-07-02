thefuck --alias | source
set -x PATH $PATH /usr/local/go/bin
op completion fish | source
set -gx EDITOR vim

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"
