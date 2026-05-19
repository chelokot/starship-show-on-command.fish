function __starship_soc_uninstall_config
    set -l config_path (__starship_soc_config_path)
    test -f "$config_path"
    or return 0

    set -l modules (__starship_soc_modules)
    set -l tmp (mktemp)

    awk -v modules="$modules" '
        BEGIN {
            in_block = 0
            in_section = 0
        }
        /^\[/ {
            in_section = 1
        }
        /^# >>> starship-show-on-command\.fish >>>$/ {
            in_block = 1
            next
        }
        /^# <<< starship-show-on-command\.fish <<<$/ {
            in_block = 0
            next
        }
        in_block {
            next
        }
        !in_section && /^format[[:space:]]*=/ {
            while ((position = index($0, modules)) > 0) {
                $0 = substr($0, 1, position - 1) substr($0, position + length(modules))
            }
        }
        {
            print
        }
    ' "$config_path" >"$tmp"

    cat "$tmp" >"$config_path"
    rm "$tmp"
    echo "updated $config_path"
end
