# Defined in - @ line 1
function ywRestartAll --wraps='yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/restartAll.ts' --description 'alias ywRestartAll yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/restartAll.ts'
  yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/restartAll.ts $argv;
end
