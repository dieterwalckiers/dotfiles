function fish_prompt -d "Write out the prompt"
    set gitbranch (fish_git_prompt)
    set gitbranchprompt ""
    if set -q gitbranch
        set gitbranchprompt $gitbranch
    end
    printf '%s%s:%s%s%s %s%s%s$ ' (set_color green) (whoami) (set_color brblue) (prompt_pwd) (set_color yellow)$gitbranchprompt(set_color normal)
end
