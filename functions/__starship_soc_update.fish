function __starship_soc_update
    set -l command_tokens (commandline -opc)
    set -l command_token

    if test (count $command_tokens) -gt 0
        set command_token $command_tokens[1]
    else
        set command_token (commandline -t)
    end

    set -l next_active

    if contains -- $command_token $starship_soc_aws_commands
        set next_active aws
    end

    if test "$STARSHIP_SOC_ACTIVE" = "$next_active"
        return
    end

    set -e STARSHIP_SOC_ACTIVE
    set -e STARSHIP_SOC_AWS
    set -e STARSHIP_SOC_AWS_CONTEXT

    switch $next_active
        case aws
            set -gx STARSHIP_SOC_ACTIVE aws
            set -gx STARSHIP_SOC_AWS 1
            set -gx STARSHIP_SOC_AWS_CONTEXT (__starship_soc_aws_context)
    end

    commandline -f repaint
end
