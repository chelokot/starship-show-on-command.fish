function __starship_soc_confirm
    set -l prompt $argv[1]
    set -l default $argv[2]

    if test "$default" = yes
        read --prompt-str "$prompt [Y/n] " --local answer
        test -z "$answer"
        or string match -qi y -- "$answer"
        or string match -qi yes -- "$answer"
    else
        read --prompt-str "$prompt [y/N] " --local answer
        string match -qi y -- "$answer"
        or string match -qi yes -- "$answer"
    end
end
