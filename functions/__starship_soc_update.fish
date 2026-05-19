function __starship_soc_update
    set -l command_token (__starship_soc_command_token)
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
