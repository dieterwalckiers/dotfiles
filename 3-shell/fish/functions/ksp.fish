# Defined in - @ line 1
function ksp --wraps='kubectl config use-context binder-prod-cluster' --description 'alias ksp kubectl config use-context binder-prod-cluster'
  kubectl config use-context binder-prod-cluster $argv;
end
