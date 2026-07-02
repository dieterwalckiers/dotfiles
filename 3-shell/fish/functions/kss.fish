# Defined in - @ line 1
function kss --wraps='kubectl config use-context binder-stg-cluster' --description 'alias kss kubectl config use-context binder-stg-cluster'
  kubectl config use-context binder-stg-cluster $argv;
end
