function __starship_soc_update
    set -l command_tokens (commandline -opc)
    set -l command_token

    if test (count $command_tokens) -gt 0
        set command_token $command_tokens[1]
    else
        set command_token (commandline -t)
    end

    set -l next_active

    for context in $starship_soc_contexts
        set -l commands_variable starship_soc_"$context"_commands
        if set -q $commands_variable; and contains -- $command_token $$commands_variable
            set next_active $context
            break
        end
    end

    if test "$STARSHIP_SOC_ACTIVE" = "$next_active"
        return
    end

    __starship_soc_clear_state

    if test -n "$next_active"
        set -l upper (string upper -- $next_active)
        set -gx STARSHIP_SOC_ACTIVE $next_active
        set -gx STARSHIP_SOC_$upper 1
        set -gx STARSHIP_SOC_"$upper"_CONTEXT (__starship_soc_context_output $next_active)
    end

    commandline -f repaint
end
