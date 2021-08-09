# Defined in - @ line 1
function ksp --wraps='kubectl config use-context binders-aks-production-admin' --description 'alias ksp kubectl config use-context binders-aks-production-admin'
  kubectl config use-context binders-aks-production-admin $argv;
end
