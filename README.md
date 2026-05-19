# starship-show-on-command.fish

Small fish bridge for Starship modules that should appear only while a matching command is being typed.

Starship does not read the live command line. This plugin does that in fish, exports small state variables, and lets Starship render ordinary custom modules from those variables.

## Install

```fish
fisher install owner/starship-show-on-command.fish
```

For local testing:

```fish
fisher install ~/Documents/Projects/starship-show-on-command.fish
```

## Starship config

Add the AWS custom module from `snippets/starship.toml` where you want it in `format`, and disable Starship's native AWS module if it is noisy:

```toml
format = "$directory${custom.aws_on_command}$character"

[custom.aws_on_command]
when = "test \"$STARSHIP_SOC_AWS\" = 1"
command = "printf '%s' \"$STARSHIP_SOC_AWS_CONTEXT\""
shell = ["sh"]
style = "bold yellow"
format = "on [$output]($style) "

[aws]
disabled = true
```

## Configure

```fish
set -g starship_soc_aws_commands aws awless cdk terraform terragrunt pulumi serverless sam
```

The default command list follows the same idea as Powerlevel10k `SHOW_ON_COMMAND`: known tools are listed explicitly.

## How it works

Fish key bindings call `__starship_soc_update` after insert, space, backspace, and delete. The function reads the first token with `commandline -opc` / `commandline -t`. If the token matches a configured command, it exports:

```text
STARSHIP_SOC_ACTIVE=aws
STARSHIP_SOC_AWS=1
STARSHIP_SOC_AWS_CONTEXT="☁️  default (us-east-1)"
```

The Starship custom module is shown while `STARSHIP_SOC_AWS=1`.

State is cleared on command execution and command cancellation.

## Commands

```fish
starship-soc status
starship-soc clear
starship-soc snippet
```

## Scope

This is intentionally small:

- fish only
- AWS provider only
- no Starship fork
- no daemon
- no persistent session state
- repaint only when active state changes

The pattern can be extended to Kubernetes or other modules by adding another provider and custom Starship module.
