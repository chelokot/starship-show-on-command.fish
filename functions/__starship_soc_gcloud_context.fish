function __starship_soc_gcloud_context
    set -l account
    set -l project

    if command -q gcloud
        if command -q timeout
            set account (command timeout 0.2s gcloud config get-value account 2>/dev/null)
            set project (command timeout 0.2s gcloud config get-value project 2>/dev/null)
        else
            set account (command gcloud config get-value account 2>/dev/null)
            set project (command gcloud config get-value project 2>/dev/null)
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
