# Defined in - @ line 1
function ldDown --wraps='ts-node ~/Source/binders-service/binders-devops-service-v1/app/src/scripts/localdev/down.ts' --description 'alias ldDown ts-node ~/Source/binders-service/binders-devops-service-v1/app/src/scripts/localdev/down.ts'
  cd ~/Source/binders-service/binders-devops-service-v1/app
  ts-node src/scripts/localdev/down.ts
end
