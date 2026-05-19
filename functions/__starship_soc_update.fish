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
    else if contains -- $command_token $starship_soc_kube_commands
        set next_active kube
    else if contains -- $command_token $starship_soc_gcloud_commands
        set next_active gcloud
    else if contains -- $command_token $starship_soc_python_commands
        set next_active python
    else if contains -- $command_token $starship_soc_memory_commands
        set next_active memory
    end

    if test "$STARSHIP_SOC_ACTIVE" = "$next_active"
        return
    end

    set -e STARSHIP_SOC_ACTIVE
    set -e STARSHIP_SOC_AWS
    set -e STARSHIP_SOC_AWS_CONTEXT
    set -e STARSHIP_SOC_KUBE
    set -e STARSHIP_SOC_KUBE_CONTEXT
    set -e STARSHIP_SOC_GCLOUD
    set -e STARSHIP_SOC_GCLOUD_CONTEXT
    set -e STARSHIP_SOC_PYTHON
    set -e STARSHIP_SOC_PYTHON_CONTEXT
    set -e STARSHIP_SOC_MEMORY

    switch $next_active
        case aws
            set -gx STARSHIP_SOC_ACTIVE aws
            set -gx STARSHIP_SOC_AWS 1
            set -gx STARSHIP_SOC_AWS_CONTEXT (__starship_soc_aws_context)
        case kube
            set -gx STARSHIP_SOC_ACTIVE kube
            set -gx STARSHIP_SOC_KUBE 1
            set -gx STARSHIP_SOC_KUBE_CONTEXT (__starship_soc_kube_context)
        case gcloud
            set -gx STARSHIP_SOC_ACTIVE gcloud
            set -gx STARSHIP_SOC_GCLOUD 1
            set -gx STARSHIP_SOC_GCLOUD_CONTEXT (__starship_soc_gcloud_context)
        case python
            set -gx STARSHIP_SOC_ACTIVE python
            set -gx STARSHIP_SOC_PYTHON 1
            set -gx STARSHIP_SOC_PYTHON_CONTEXT (__starship_soc_python_context)
        case memory
            set -gx STARSHIP_SOC_ACTIVE memory
            set -gx STARSHIP_SOC_MEMORY 1
    end

    commandline -f repaint
end
