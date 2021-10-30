# update & upgrade
sudo apt update
sudo apt upgrade
# mdless
sudo snap install mdless
# git
sudo apt install git
git config --global user.email "d.walckiers@protonmail.com"
git config --global user.name "Dieter Walckiers"
# build-essential, includes the "make" command
sudo apt install build-essential
# slack
sudo snap install slack --classic
# vscode
sudo snap install code --classic
# info: settings sync in vscode is through github account
# helper tools
sudo apt install xclip
# python, so we can use pip
sudo apt install python3-dev python3-pip python3-setuptools
# thefuck (correct commands)
sudo pip3 install thefuck
# conntrack (needed for minikube)
sudo apt-get install -y conntrack
