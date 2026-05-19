function __starship_soc_python_context
    set -l python_version

    if command -q python3
        set python_version (command python3 --version 2>/dev/null | string replace 'Python ' '')
    else if command -q python
        set python_version (command python --version 2>/dev/null | string replace 'Python ' '')
    end

    set -l label " python"

    if test -n "$python_version"
        set label "$label $python_version"
    end

    if set -q VIRTUAL_ENV
        set label "$label ("(basename "$VIRTUAL_ENV")")"
    end

    printf '%s' "$label"
end
