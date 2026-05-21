set -l repo_root (realpath (dirname (status --current-filename))/..)
set -l config_home (mktemp -d)

set -gx XDG_CONFIG_HOME "$config_home"
set -gx STARSHIP_CONFIG "$config_home/starship.toml"
set -p fish_function_path "$repo_root/functions"

source "$repo_root/conf.d/starship_show_on_command.fish"

starship-soc install --yes
starship explain >/dev/null

starship-soc install --yes
starship explain >/dev/null

set -l marker_count (string match '# >>> starship-show-on-command.fish >>>' <"$STARSHIP_CONFIG" | count)
if test "$marker_count" -ne 1
    echo "expected one managed block, got $marker_count" >&2
    exit 1
end

set -l format_count (string match --regex '^\s*format\s*=' <"$STARSHIP_CONFIG" | count)
if test "$format_count" -ne 5
    echo "expected one top-level format and four custom module formats, got $format_count" >&2
    exit 1
end

set -l custom_format_count (string match --all --regex '\$\{custom\.[a-z_]+_on_command\}' <"$STARSHIP_CONFIG" | count)
if test "$custom_format_count" -ne 4
    echo "expected four custom modules in prompt format, got $custom_format_count" >&2
    exit 1
end

rm -rf "$config_home"
