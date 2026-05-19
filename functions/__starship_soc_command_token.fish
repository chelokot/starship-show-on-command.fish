function __starship_soc_command_token
    set -l process_tokens (commandline --current-process --tokens-expanded --cut-at-cursor)

    if test (count $process_tokens) -gt 0
        printf '%s' $process_tokens[1]
        return
    end

    printf '%s' (commandline --current-token --cut-at-cursor)
end
