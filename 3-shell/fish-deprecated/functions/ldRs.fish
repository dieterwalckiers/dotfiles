# Defined in - @ line 1
function ldRs --wraps='ts-node ~/Source/binders-service/binders-devops-service-v1/app/src/scripts/localdev/restartAll.ts' --description 'alias ldRs ts-node ~/Source/binders-service/binders-devops-service-v1/app/src/scripts/localdev/restartAll.ts'
  cd ~/Source/binders-service/binders-devops-service-v1/app
  ts-node src/scripts/localdev/restartAll.ts
end
