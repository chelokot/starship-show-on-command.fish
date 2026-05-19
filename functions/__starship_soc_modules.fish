function __starship_soc_modules
    for context in $starship_soc_contexts
        printf '${custom.%s_on_command}' $context
    end
end
