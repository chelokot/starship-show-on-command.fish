function __starship_soc_ensure_starship
    set -l assume_yes $argv[1]

    if command -sq starship
        return 0
    end

    echo 'starship-soc requires Starship, but `starship` was not found in PATH.' >&2
    echo >&2
    echo 'Install Starship now using the official installer?' >&2
    echo 'https://starship.rs/install.sh' >&2
    echo >&2
    echo 'This will run:' >&2
    echo 'curl -sS https://starship.rs/install.sh | sh -s -- --yes' >&2
    echo >&2

    if test -z "$assume_yes"
        __starship_soc_confirm "Install Starship now?"
        or return 127
    end

    if not command -sq curl
        echo "starship-soc cannot run the official Starship installer because curl was not found in PATH." >&2
        return 127
    end

    if not command -sq sh
        echo "starship-soc cannot run the official Starship installer because sh was not found in PATH." >&2
        return 127
    end

    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    set -l installer_status $pipestatus
    for command_status in $installer_status
        if test "$command_status" -ne 0
            echo "Starship installer failed." >&2
            return $command_status
        end
    end

    if not command -sq starship
        echo 'Starship installer finished, but `starship` is still not available in PATH. Restart your shell or check https://starship.rs/' >&2
        return 127
    end
end
