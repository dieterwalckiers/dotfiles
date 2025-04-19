# Defined in - @ line 1
function klog
  kubectl logs -n develop local-dev -c $argv
end
