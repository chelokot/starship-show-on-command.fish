function __starship_soc_patch_format
    set -l config_path $argv[1]
    set -l modules (__starship_soc_modules)
    set -l tmp (mktemp)

    awk -v modules="$modules" '
        BEGIN {
            saw_format = 0
            in_section = 0
        }
        /^\[/ {
            in_section = 1
        }
        !in_section && /^format[[:space:]]*=/ {
            saw_format = 1
            if (index($0, "${custom.aws_on_command}") == 0) {
                if (index($0, "$line_break") > 0) {
                    sub(/\$line_break/, modules "$line_break")
                } else if (index($0, "$character") > 0) {
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
end
