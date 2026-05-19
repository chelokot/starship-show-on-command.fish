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
            __starship_soc_snippet
        case install
            __starship_soc_install
        case uninstall
            __starship_soc_uninstall_config
        case '*'
            echo "usage: starship-soc status|clear|snippet|install|uninstall" >&2
            return 2
    end
end
