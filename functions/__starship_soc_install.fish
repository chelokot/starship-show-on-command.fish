function __starship_soc_install
    set -l config_path (__starship_soc_config_path)
    set -l config_dir (dirname "$config_path")
    mkdir -p "$config_dir"

    if not test -f "$config_path"
        printf 'format = "$directory%s$character"\n\n' (__starship_soc_modules) >"$config_path"
    end

    set -l modules (__starship_soc_modules)
    set -l tmp (mktemp)

    awk -v modules="$modules" '
        BEGIN {
            in_block = 0
            saw_format = 0
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
            saw_format = 1
            if (index($0, "${custom.aws_on_command}") == 0) {
                if (index($0, "$character") > 0) {
                    sub(/\$character/, modules "$character")
                } else {
                    sub(/"$/, modules "\"")
                }
            }
        }
        {
            print
        }
        END {
            if (!saw_format) {
                print "format = \"$directory" modules "$character\""
                print ""
            }
        }
    ' "$config_path" >"$tmp"

    cat "$tmp" >"$config_path"
    rm "$tmp"

    for module in aws kubernetes gcloud python
        __starship_soc_disable_native_module "$config_path" "$module"
    end

    printf '\n' >>"$config_path"
    __starship_soc_snippet --custom-only >>"$config_path"

    echo "updated $config_path"
end
