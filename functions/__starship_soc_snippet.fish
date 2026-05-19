function __starship_soc_snippet
    set -l custom_only
    test "$argv[1]" = --custom-only
    and set custom_only 1

    printf '%s\n' '# >>> starship-show-on-command.fish >>>'
    for context in $starship_soc_contexts
        set -l upper (string upper -- $context)
        set -l style_variable starship_soc_"$context"_style
        set -l format_variable starship_soc_"$context"_format
        set -l style $$style_variable
        set -l format $$format_variable

        test -n "$style"
        or set style "bold cyan"
        test -n "$format"
        or set format 'on [$output]($style) '

        printf '%s\n' "[custom.$context"_on_command"]"
        printf 'when = "test \\\\"$STARSHIP_SOC_%s\\\\" = 1"\n' $upper
        printf 'command = "printf '\''%%s'\'' \\\\"$STARSHIP_SOC_%s_CONTEXT\\\\""\n' $upper
        printf '%s\n' 'shell = ["sh"]'
        printf 'style = "%s"\n' $style
        printf 'format = "%s"\n' $format
        printf '\n'
    end

    if test -z "$custom_only"
        printf '\n'
        printf '%s\n' '[aws]'
        printf '%s\n' 'disabled = true'
        printf '\n'
        printf '%s\n' '[kubernetes]'
        printf '%s\n' 'disabled = true'
        printf '\n'
        printf '%s\n' '[gcloud]'
        printf '%s\n' 'disabled = true'
        printf '\n'
        printf '%s\n' '[python]'
        printf '%s\n' 'disabled = true'
    end

    printf '%s\n' '# <<< starship-show-on-command.fish <<<'
end
