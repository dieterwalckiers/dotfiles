# Defined in - @ line 1
function jl --wraps=/usr/bin/journal-today.sh --wraps=/usr/bin/myjournal.sh --description 'alias jl /usr/bin/myjournal.sh'
  /usr/bin/myjournal.sh  $argv;
end
