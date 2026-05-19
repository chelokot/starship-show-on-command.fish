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

    set_color --bold
    echo "Starship config: $config_path"
    set_color normal
    echo "This will set up Starship to show AWS/Kubernetes/GCloud/Python/system context only while matching commands are being typed."
    echo "It can also hide Starship's always-on versions of those modules, so the prompt does not show the same context twice."
    set_color yellow
    echo "It edits this config file: adds a managed block, updates top-level format, and may set aws/kubernetes/gcloud/python disabled = true."
    echo "A timestamped backup is created before any change."
    set_color normal
    set_color --dim
    echo "Manual setup: run `starship-soc snippet` and edit your Starship config yourself."
    set_color normal

    if test -z "$assume_yes"
        __starship_soc_confirm "Continue?"
        or return 1
    end

    set -l backup_path "$config_path.bak."(date +%Y%m%d%H%M%S)
    cp "$config_path" "$backup_path"
    echo "Backup: $backup_path"

    if test -n "$assume_yes"; or __starship_soc_confirm "Add/update Starship custom module definitions?" yes
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

    if test -n "$assume_yes"; or __starship_soc_confirm "Show these modules in your prompt format?" yes
        __starship_soc_patch_format "$config_path"
    end

    if test -n "$assume_yes"; or __starship_soc_confirm "Hide always-on aws/kubernetes/gcloud/python modules?" yes
        for module in aws kubernetes gcloud python
            __starship_soc_disable_native_module "$config_path" "$module"
        end
    end

    echo "updated $config_path"
end
