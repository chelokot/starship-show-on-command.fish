function __starship_soc_aws_context
    set -l profile default
    set -q AWS_PROFILE
    and set profile $AWS_PROFILE

    set -l region
    set -q AWS_REGION
    and set region $AWS_REGION

    if test -z "$region"
        set -q AWS_DEFAULT_REGION
        and set region $AWS_DEFAULT_REGION
    end

    set -l account
    set -l section default
    test "$profile" = default
    or set section "profile $profile"

    if test -r "$HOME/.aws/config"
        set -l parsed (awk -F= -v section="$section" '
            function trim(value) {
                gsub(/^[ \t]+|[ \t]+$/, "", value)
                return value
            }
            /^\[/ {
                current = $0
                gsub(/^\[|\]$/, "", current)
                active = current == section
                next
            }
            active {
                key = trim($1)
                value = trim($2)
                if (key == "region") region = value
                if (key == "sso_account_id") account = value
            }
            END {
                print region
                print account
            }
        ' "$HOME/.aws/config")

        if test -z "$region"
            set region $parsed[1]
        end

        if test (count $parsed) -gt 1
            set account $parsed[2]
        end
    end

    set -l context "☁️  $profile"

    if test -n "$account"
        set context "$context@$account"
    end

    if test -n "$region"
        set context "$context ($region)"
    end

    printf '%s' "$context"
end
