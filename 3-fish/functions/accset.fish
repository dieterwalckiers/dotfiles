# Defined in - @ line 1
function accset
  set -l acc
  if test $argv[1] = prod
    set acc 0370c56f-76ae-4423-8da8-c391ad332bf4
  end
  if test $argv[1] = newprod
    set acc 93eddcda-b319-4357-9de4-cb610ae0ede9
  end
  if test $argv[1] = nonprod
    set acc df893890-4da6-47bc-8a71-2ec64776511a
  end
  az account set -s $acc
end
