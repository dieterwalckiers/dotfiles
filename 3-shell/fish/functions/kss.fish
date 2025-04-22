# Defined in - @ line 1
function kss --wraps='kubectl config use-context binders-aks-staging-admin' --description 'alias kss kubectl config use-context binders-aks-staging-admin'
  kubectl config use-context binders-aks-staging-admin $argv;
end
