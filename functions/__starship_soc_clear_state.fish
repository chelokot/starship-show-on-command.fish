function __starship_soc_clear_state
    set -e STARSHIP_SOC_ACTIVE

    for context in $starship_soc_contexts
        set -l upper (string upper -- $context)
        set -e STARSHIP_SOC_$upper
        set -e STARSHIP_SOC_"$upper"_CONTEXT
    end
end
