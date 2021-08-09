# Defined in - @ line 1
function kn --wraps='kubectl -n' --description 'alias kn kubectl -n'
  kubectl -n $argv;
end
