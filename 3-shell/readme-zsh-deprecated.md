install zsh via apt (more info here https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)

to be added to .zshrc:
# dyte custom
source ~/.nvm/nvm.sh
eval $(thefuck --alias)
alias ksp="kubectl config use-context binders-aks-production-admin"
alias ksnp="kubectl config use-context binder-prod-cluster-admin"
alias ksl="kubectl config use-context minikube"
alias kcc="kubectl config current-context"
alias src="cd ~/source"
alias klog="kubectl logs -n develop local-dev -c $argv"


then install:
https://github.com/zsh-users/zsh-autosuggestions
