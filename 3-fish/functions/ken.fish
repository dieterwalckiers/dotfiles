# Defined in - @ line 1
function ken
  set -g -x CURRENT_K8S_NAMESPACE $argv
  echo "Current namespace set to: '$CURRENT_K8S_NAMESPACE'"
end
