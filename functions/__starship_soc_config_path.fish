function __starship_soc_config_path
    if set -q STARSHIP_CONFIG
        printf '%s\n' "$STARSHIP_CONFIG"
    else if set -q XDG_CONFIG_HOME
        printf '%s\n' "$XDG_CONFIG_HOME/starship.toml"
    else
        printf '%s\n' "$HOME/.config/starship.toml"
    end
end
