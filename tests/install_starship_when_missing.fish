set -l repo_root (realpath (dirname (status --current-filename))/..)
set -l config_home (mktemp -d)
set -l bin_dir "$config_home/bin"

mkdir -p "$bin_dir"
for command_name in awk cat chmod cp date dirname env mkdir mktemp rm touch
    /usr/bin/ln -s "/usr/bin/$command_name" "$bin_dir/$command_name"
end

printf '%s\n' \
    '#!/bin/sh' \
    ': > "$STARSHIP_FAKE_BIN/curl-called"' \
    'printf "%s\n" "# official Starship installer placeholder"' \
    >"$bin_dir/curl"

printf '%s\n' \
    '#!/bin/sh' \
    ': > "$STARSHIP_FAKE_BIN/sh-called"' \
    'while read -r line; do :; done' \
    'printf "%s\n" "#!/bin/sh" "exit 0" > "$STARSHIP_FAKE_BIN/starship"' \
    '/usr/bin/chmod +x "$STARSHIP_FAKE_BIN/starship"' \
    >"$bin_dir/sh"

/usr/bin/chmod +x "$bin_dir/curl" "$bin_dir/sh"

set -gx XDG_CONFIG_HOME "$config_home"
set -gx STARSHIP_CONFIG "$config_home/starship.toml"
set -gx STARSHIP_FAKE_BIN "$bin_dir"
set -gx PATH "$bin_dir"
set -p fish_function_path "$repo_root/functions"

source "$repo_root/conf.d/starship_show_on_command.fish"

set -l output (starship-soc install --yes 2>&1)
set -l install_status $status

if test "$install_status" -ne 0
    echo "expected install to install starship and succeed, got $install_status: $output" >&2
    /usr/bin/rm -rf "$config_home"
    exit 1
end

if not string match -q '*curl -sS https://starship.rs/install.sh | sh -s -- --yes*' -- $output
    echo "missing official installer command in output: $output" >&2
    /usr/bin/rm -rf "$config_home"
    exit 1
end

if not test -e "$bin_dir/curl-called"
    echo "expected install to call curl" >&2
    /usr/bin/rm -rf "$config_home"
    exit 1
end

if not test -e "$bin_dir/sh-called"
    echo "expected install to call sh" >&2
    echo "unexpected output: $output" >&2
    /usr/bin/rm -rf "$config_home"
    exit 1
end

if not test -e "$STARSHIP_CONFIG"
    echo "install did not create config after installing starship" >&2
    /usr/bin/rm -rf "$config_home"
    exit 1
end

/usr/bin/rm -rf "$config_home"
