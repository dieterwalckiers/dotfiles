# Defined in - @ line 1
function getElasticPasswordDevelop
  set -l pw kubectl -n develop get secret binders-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
  echo $pw
end
