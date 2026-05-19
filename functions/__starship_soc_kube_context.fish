function __starship_soc_kube_context
    set -l context
    set -l namespace

    if command -q kubectl
        if command -q timeout
            set context (command timeout 0.2s kubectl config current-context 2>/dev/null)
            set namespace (command timeout 0.2s kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
        else
            set context (command kubectl config current-context 2>/dev/null)
            set namespace (command kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
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
