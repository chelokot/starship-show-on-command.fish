function starship-soc
    switch $argv[1]
        case status
            echo "active: "(set -q STARSHIP_SOC_ACTIVE; and echo $STARSHIP_SOC_ACTIVE; or echo none)
            echo "aws commands: $starship_soc_aws_commands"
            echo "kube commands: $starship_soc_kube_commands"
            echo "gcloud commands: $starship_soc_gcloud_commands"
            echo "python commands: $starship_soc_python_commands"
            echo "memory commands: $starship_soc_memory_commands"
        case clear
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
            commandline -f repaint 2>/dev/null
        case snippet
            printf '%s\n' '[custom.aws_on_command]'
            printf '%s\n' 'when = "test \"$STARSHIP_SOC_AWS\" = 1"'
            printf '%s\n' 'command = "printf '\''%s'\'' \"$STARSHIP_SOC_AWS_CONTEXT\""'
            printf '%s\n' 'shell = ["sh"]'
            printf '%s\n' 'style = "bold yellow"'
            printf '%s\n' 'format = "on [$output]($style) "'
            printf '\n'
            printf '%s\n' '[custom.kube_on_command]'
            printf '%s\n' 'when = "test \"$STARSHIP_SOC_KUBE\" = 1"'
            printf '%s\n' 'command = "printf '\''%s'\'' \"$STARSHIP_SOC_KUBE_CONTEXT\""'
            printf '%s\n' 'shell = ["sh"]'
            printf '%s\n' 'style = "bold blue"'
            printf '%s\n' 'format = "on [$output]($style) "'
            printf '\n'
            printf '%s\n' '[custom.gcloud_on_command]'
            printf '%s\n' 'when = "test \"$STARSHIP_SOC_GCLOUD\" = 1"'
            printf '%s\n' 'command = "printf '\''%s'\'' \"$STARSHIP_SOC_GCLOUD_CONTEXT\""'
            printf '%s\n' 'shell = ["sh"]'
            printf '%s\n' 'style = "bold blue"'
            printf '%s\n' 'format = "on [$output]($style) "'
            printf '\n'
            printf '%s\n' '[custom.python_on_command]'
            printf '%s\n' 'when = "test \"$STARSHIP_SOC_PYTHON\" = 1"'
            printf '%s\n' 'command = "printf '\''%s'\'' \"$STARSHIP_SOC_PYTHON_CONTEXT\""'
            printf '%s\n' 'shell = ["sh"]'
            printf '%s\n' 'style = "bold green"'
            printf '%s\n' 'format = "via [$output]($style) "'
            printf '\n'
            printf '%s\n' '[custom.memory_on_command]'
            printf '%s\n' 'when = "test \"$STARSHIP_SOC_MEMORY\" = 1"'
            printf '%s\n' 'command = "printf '\''%s'\'' '\''󰍛 memory'\''"'
            printf '%s\n' 'shell = ["sh"]'
            printf '%s\n' 'style = "bold purple"'
            printf '%s\n' 'format = "via [$output]($style) "'
        case '*'
            echo "usage: starship-soc status|clear|snippet" >&2
            return 2
    end
end
