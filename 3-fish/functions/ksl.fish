# Defined in - @ line 1
function ksl --wraps='kubectl config use-context minikube' --description 'alias ksl kubectl config use-context minikube'
  kubectl config use-context minikube $argv;
end
