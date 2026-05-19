function __starship_soc_context_output
    set -l context $argv[1]
    set -l function_name __starship_soc_"$context"_context
    set -l label_variable starship_soc_"$context"_label

    if functions -q $function_name
        $function_name
    else if set -q $label_variable
        printf '%s' $$label_variable
    else
        printf '%s' $context
    end
end
