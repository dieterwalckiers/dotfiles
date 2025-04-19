# Defined in - @ line 1
function doco --wraps=docker-compose --description 'alias doco docker-compose'
  docker-compose  $argv;
end
