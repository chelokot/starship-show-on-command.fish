function __starship_soc_gcloud_context
    set -l account
    set -l project
    set -l config_home

    if set -q CLOUDSDK_CONFIG
        set config_home $CLOUDSDK_CONFIG
    else
        set config_home "$HOME/.config/gcloud"
    end

    set -l active_config default
    if test -r "$config_home/active_config"
        set active_config (string trim -- (cat "$config_home/active_config"))
    end

    set -l config_file "$config_home/configurations/config_$active_config"
    if test -r "$config_file"
        set -l parsed (awk -F= '
            function trim(value) {
                gsub(/^[ \t]+|[ \t]+$/, "", value)
                return value
            }
            /^\[/ {
                section = $0
                gsub(/^\[|\]$/, "", section)
                next
            }
            section == "core" {
                key = trim($1)
                value = trim($2)
                if (key == "account") account = value
                if (key == "project") project = value
            }
            END {
                print account
                print project
            }
        ' "$config_file")

        set account $parsed[1]
        if test (count $parsed) -gt 1
            set project $parsed[2]
        end
    end

    set -l label "☁️  gcloud"

    if test -n "$account"
        set label "☁️  $account"
    end

    if test -n "$project"
        set label "$label@$project"
    end

    printf '%s' "$label"
end
