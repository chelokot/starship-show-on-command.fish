set -l repo_root (realpath (dirname (status --current-filename))/..)
set -l config_home (mktemp -d)

set -gx XDG_CONFIG_HOME "$config_home"
set -gx STARSHIP_CONFIG "$config_home/starship.toml"
set -p fish_function_path "$repo_root/functions"

source "$repo_root/conf.d/starship_show_on_command.fish"

printf '%s\n' 'format = "$character"' 'format = "$directory"' >"$STARSHIP_CONFIG"

set -l output (starship-soc install --yes 2>&1)
set -l install_status $status

if test "$install_status" -eq 0
    echo "expected install to fail for invalid resulting config" >&2
    rm -rf "$config_home"
    exit 1
end

if not string match -q 'starship-soc generated an invalid Starship config; restored backup: *' -- $output
    echo "missing restore error in output: $output" >&2
    rm -rf "$config_home"
    exit 1
end

if not string match -q '*Unable to parse the config file*' -- $output
    echo "missing starship parse error in output: $output" >&2
    rm -rf "$config_home"
    exit 1
end

if test (cat "$STARSHIP_CONFIG" | string collect) != (printf '%s\n' 'format = "$character"' 'format = "$directory"' | string collect)
    echo "expected restored backup config" >&2
    rm -rf "$config_home"
    exit 1
end

rm -rf "$config_home"
