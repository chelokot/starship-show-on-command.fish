function __starship_soc_kube_context
    set -l context
    set -l namespace
    set -l kubeconfig_files

    if set -q KUBECONFIG
        set kubeconfig_files (string split : -- $KUBECONFIG)
    else
        set kubeconfig_files "$HOME/.kube/config"
    end

    set -l readable_files
    for file in $kubeconfig_files
        if test -f "$file"; and test -r "$file"
            set -a readable_files "$file"
        end
    end

    if test (count $readable_files) -gt 0
        set -l parsed (awk '
            function trim(value) {
                gsub(/^[ \t]+|[ \t]+$/, "", value)
                return value
            }
            /^current-context:[ \t]*/ {
                current = trim(substr($0, index($0, ":") + 1))
                next
            }
            /^contexts:[ \t]*$/ {
                in_contexts = 1
                next
            }
            /^[A-Za-z0-9_-]+:[ \t]*$/ && $0 !~ /^contexts:/ {
                in_contexts = 0
                in_item = 0
            }
            in_contexts && /^- context:[ \t]*$/ {
                in_item = 1
                namespace = ""
                next
            }
            in_contexts && in_item && /^[ \t]+namespace:[ \t]*/ {
                namespace = trim(substr($0, index($0, ":") + 1))
                next
            }
            in_contexts && in_item && /^[ \t]+name:[ \t]*/ {
                name = trim(substr($0, index($0, ":") + 1))
                namespaces[name] = namespace
                in_item = 0
                next
            }
            END {
                print current
                print namespaces[current]
            }
        ' $readable_files)

        set context $parsed[1]
        if test (count $parsed) -gt 1
            set namespace $parsed[2]
        end
    end

    if test -z "$context"
        set context kube
    end

    set -l label "☸ $context"

    if test -n "$namespace"
        set label "$label/$namespace"
    end

    printf '%s' "$label"
end
