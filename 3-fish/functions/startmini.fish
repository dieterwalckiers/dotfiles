# Defined in - @ line 1
function startmini --wraps='sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube start --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf --vm-driver=none' --description 'alias startmini sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube start --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf --vm-driver=none'
  sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube start --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf --vm-driver=none $argv;
end
