# Defined in - @ line 1
function startmini --wraps='sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube start --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf --vm-driver=none --kubernetes-version=1.22.11' --description 'alias startmini sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube start --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf --vm-driver=none --kubernetes-version=1.22.11'
  sudo -E CHANGE_MINIKUBE_NONE_USER=true minikube start --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf --vm-driver=none --kubernetes-version=1.22.11 $argv;
end
