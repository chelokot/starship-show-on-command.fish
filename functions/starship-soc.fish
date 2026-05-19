function starship-soc
    switch $argv[1]
        case status
            echo "active: "(set -q STARSHIP_SOC_ACTIVE; and echo $STARSHIP_SOC_ACTIVE; or echo none)
            for context in $starship_soc_contexts
                set -l commands_variable starship_soc_"$context"_commands
                echo "$context commands: "(string join " " -- $$commands_variable)
            end
        case clear
            __starship_soc_clear_state
            commandline -f repaint 2>/dev/null
        case snippet
            __starship_soc_snippet
        case install
            __starship_soc_install $argv[2..-1]
        case uninstall
            __starship_soc_uninstall_config
        case '*'
            echo "usage: starship-soc status|clear|snippet|install [--yes]|uninstall" >&2
            return 2
    end
end
