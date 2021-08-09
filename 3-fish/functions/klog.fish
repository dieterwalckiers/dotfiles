# Defined in - @ line 1
function klog
  kubectl logs -f -n develop local-dev -c $argv --tail 100
end
