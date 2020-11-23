# Defined in - @ line 1
function stopmini --wraps='sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube stop' --description 'alias stopmini sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube stop'
  sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube stop $argv;
end
