function __starship_soc_update
    set -l command_tokens (__starship_soc_command_tokens)
    set -l next_active

    for context in $starship_soc_contexts
        set -l commands_variable starship_soc_"$context"_commands
        if not set -q $commands_variable
            continue
        end

        for command_token in $command_tokens
            if contains -- $command_token $$commands_variable
                set -a next_active $context
                break
            end
        end
    end

    set -l next_active_key (string join ' ' -- $next_active)

    if test "$STARSHIP_SOC_ACTIVE" = "$next_active_key"
        return
    end

    __starship_soc_clear_state

    if test -n "$next_active_key"
        set -gx STARSHIP_SOC_ACTIVE $next_active_key

        for context in $next_active
            set -l upper (string upper -- $context)
            set -gx STARSHIP_SOC_$upper 1
            set -gx STARSHIP_SOC_"$upper"_CONTEXT (__starship_soc_context_output $context)
        end
    end

    commandline -f repaint
end
