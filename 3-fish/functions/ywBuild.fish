# Defined in - @ line 1
function ywBuild --wraps='yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/build.ts' --description 'alias ywBuild yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/build.ts'
  yarn workspace @binders/devops-v1 ts-node src/scripts/localdev/build.ts $argv;
end
