# Defined in - @ line 1
function kcc --wraps='kubectl config current-context' --description 'alias kcc kubectl config current-context'
  kubectl config current-context $argv;
end
