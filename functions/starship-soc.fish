function starship-soc
    switch $argv[1]
        case status
            echo "active: "(set -q STARSHIP_SOC_ACTIVE; and echo $STARSHIP_SOC_ACTIVE; or echo none)
            echo "aws commands: $starship_soc_aws_commands"
        case clear
            set -e STARSHIP_SOC_ACTIVE
            set -e STARSHIP_SOC_AWS
            set -e STARSHIP_SOC_AWS_CONTEXT
            commandline -f repaint 2>/dev/null
        case snippet
            printf '%s\n' '[custom.aws_on_command]'
            printf '%s\n' 'when = "test \"$STARSHIP_SOC_AWS\" = 1"'
            printf '%s\n' 'command = "printf '\''%s'\'' \"$STARSHIP_SOC_AWS_CONTEXT\""'
            printf '%s\n' 'shell = ["sh"]'
            printf '%s\n' 'style = "bold yellow"'
            printf '%s\n' 'format = "on [$output]($style) "'
        case '*'
            echo "usage: starship-soc status|clear|snippet" >&2
            return 2
    end
end
