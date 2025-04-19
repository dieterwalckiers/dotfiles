first, check if this repo / installation method is still up-to-date (https://github.com/fish-shell/fish-shell)

sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish
chsh -s /usr/bin/fish


then copy the config file to ~/.config/fish/config


additionally, install fisher plugin manager
curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher

install nvm, procedure is slightly different for fish:
see: https://eshlox.net/2019/01/27/how-to-use-nvm-with-fish-shell


