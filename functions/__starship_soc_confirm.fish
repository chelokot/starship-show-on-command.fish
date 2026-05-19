function __starship_soc_confirm
    set -l prompt $argv[1]
    read --prompt-str "$prompt [y/N] " --local answer
    string match -qi y -- "$answer"
    or string match -qi yes -- "$answer"
end
