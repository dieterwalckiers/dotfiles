# Defined in - @ line 1
function ywUp --wraps='yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/up.ts' --wraps='yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/up.ts -s -e' --description 'alias ywUp yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/up.ts -s -e'
  yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/up.ts -s -e $argv;
end
