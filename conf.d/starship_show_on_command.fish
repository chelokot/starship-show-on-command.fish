set -q starship_soc_aws_commands
or set -g starship_soc_aws_commands aws awless cdk terraform terragrunt pulumi serverless sam

function __starship_soc_bind_mode
    set -l mode $argv[1]

    bind -M $mode '' self-insert __starship_soc_update
    bind -M $mode space expand-abbr 'commandline -i " "' __starship_soc_update
    bind -M $mode backspace backward-delete-char __starship_soc_update
    bind -M $mode delete delete-char __starship_soc_update
end

__starship_soc_bind_mode insert

set -l default_empty_binding (bind -M default '' 2>/dev/null | string collect)
if string match -q '*self-insert*' -- $default_empty_binding
    __starship_soc_bind_mode default
end

function __starship_soc_clear --on-event fish_preexec --on-event fish_cancel
    set -e STARSHIP_SOC_ACTIVE
    set -e STARSHIP_SOC_AWS
    set -e STARSHIP_SOC_AWS_CONTEXT
end

function __starship_soc_uninstall --on-event starship_show_on_command_uninstall --on-event starship_show_on_command_fish_uninstall
    bind -M insert --erase ''
    bind -M insert --erase space
    bind -M insert --erase backspace
    bind -M insert --erase delete
    bind -M default --erase ''
    bind -M default --erase space
    bind -M default --erase backspace
    bind -M default --erase delete
end
