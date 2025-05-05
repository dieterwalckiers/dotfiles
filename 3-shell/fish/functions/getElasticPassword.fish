function getElasticPassword
    set namespace (test (count $argv) -gt 0; and echo $argv[1]; or echo develop)
    set password (kubectl -n $namespace get secret binders-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
    echo $password
end

