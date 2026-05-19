function __starship_soc_disable_native_module
    set -l config_path $argv[1]
    set -l module $argv[2]
    set -l tmp (mktemp)

    awk -v module="$module" '
        BEGIN {
            in_target = 0
            saw_target = 0
            saw_disabled = 0
        }
        function close_target() {
            if (in_target && !saw_disabled) {
                print "disabled = true"
            }
            in_target = 0
            saw_disabled = 0
        }
        /^\[/ {
            close_target()
            section = $0
            gsub(/^\[|\]$/, "", section)
            if (section == module) {
                in_target = 1
                saw_target = 1
            }
        }
        in_target && /^[[:space:]]*disabled[[:space:]]*=/ {
            print "disabled = true"
            saw_disabled = 1
            next
        }
        {
            print
        }
        END {
            close_target()
            if (!saw_target) {
                print ""
                print "[" module "]"
                print "disabled = true"
            }
        }
    ' "$config_path" >"$tmp"

    cat "$tmp" >"$config_path"
    rm "$tmp"
end
