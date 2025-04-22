# Defined in - @ line 1
function rmjuju --wraps='sudo rm /tmp/juju*' --description 'alias rmjuju sudo rm /tmp/juju*'
  sudo rm /tmp/juju* $argv;
end
