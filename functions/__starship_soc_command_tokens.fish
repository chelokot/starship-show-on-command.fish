function __starship_soc_command_tokens
    set -l buffer (commandline --current-buffer --cut-at-cursor | string collect)
    set -l segments (string replace --all --regex '&&|\|\||[|;&]|\n|\band\b|\bor\b' \n -- "$buffer")

    for segment in $segments
        set -l trimmed (string trim -- $segment)
        if test -z "$trimmed"
            continue
        end

        set -l command_token (string match --regex '^\S+' -- $trimmed)
        if test -n "$command_token"
            printf '%s\n' $command_token
        end
    end
end
