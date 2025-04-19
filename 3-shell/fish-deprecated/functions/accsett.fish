# Defined in - @ line 1
function accsett
  set -l acc "init"
  if test $argv[1] = "prod"
    set -lae acc 0370c56f-76ae-4423-8da8-c391ad332bf4
  end
  if test $argv[1] = "newprod"
    set -lae acc 93eddcda-b319-4357-9de4-cb610ae0ede9
  end
  if test $argv[1] = "nonprod"
    set -lae acc df893890-4da6-47bc-8a71-2ec64776511a
  end
  echo "now"
  echo $acc
end
