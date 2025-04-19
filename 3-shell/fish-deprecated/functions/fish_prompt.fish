function fish_prompt -d "Write out the prompt"
    set k8scontext (cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //")
    set gitbranch (fish_git_prompt)
    set k8scontextprompt ""
    set gitbranchprompt ""
    if set -q k8scontext
        set k8scontextprompt \(k8s: $k8scontext\)
    end
    if set -q gitbranch
        set gitbranchprompt $gitbranch
    end
    printf '%s%s %s%s' (set_color yellow) $k8scontextprompt (set_color bryellow) $gitbranchprompt
    printf '
%s%s:%s%s%s $ ' (set_color green) (whoami) (set_color brblue) (prompt_pwd) (set_color normal)
end
