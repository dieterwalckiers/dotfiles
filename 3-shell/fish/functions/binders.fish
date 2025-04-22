# Defined in - @ line 1
function binders --wraps='cd ~/Source/binders' --wraps='cd ~/Source/binders-service' --description 'alias binders cd ~/Source/binders-service'
  cd ~/Source/binders-service $argv;
end
