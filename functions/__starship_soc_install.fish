function __starship_soc_install
    set -l assume_yes
    if contains -- --yes $argv
        set assume_yes 1
    end

    set -l config_path (__starship_soc_config_path)
    set -l config_dir (dirname "$config_path")
    mkdir -p "$config_dir"

    if not test -f "$config_path"
        touch "$config_path"
    end

    echo "Starship config: $config_path"
    echo "This can add managed custom modules, insert them into top-level format, and disable native duplicates."
    echo "Manual alternative: run `starship-soc snippet` and edit your Starship config yourself."

    if test -z "$assume_yes"
        __starship_soc_confirm "Continue?"
        or return 1
    end

    set -l backup_path "$config_path.bak."(date +%Y%m%d%H%M%S)
    cp "$config_path" "$backup_path"
    echo "Backup: $backup_path"

    if test -n "$assume_yes"; or __starship_soc_confirm "Add/update managed custom module definitions?"
        set -l tmp (mktemp)
        awk '
            BEGIN {
                in_block = 0
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
            {
                print
            }
        ' "$config_path" >"$tmp"
        cat "$tmp" >"$config_path"
        rm "$tmp"
        printf '\n' >>"$config_path"
        __starship_soc_snippet --custom-only >>"$config_path"
    end

    if test -n "$assume_yes"; or __starship_soc_confirm "Insert show-on-command modules into top-level format?"
        __starship_soc_patch_format "$config_path"
    end

    if test -n "$assume_yes"; or __starship_soc_confirm "Disable native aws/kubernetes/gcloud/python modules to avoid duplicates?"
        for module in aws kubernetes gcloud python
            __starship_soc_disable_native_module "$config_path" "$module"
        end
    end

    echo "updated $config_path"
end
