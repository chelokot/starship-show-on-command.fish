# starship-show-on-command.fish

Show selected Starship custom modules only while typing matching commands in fish.

## Install

```fish
fisher install chelokot/starship-show-on-command.fish
```

## Starship

Add the modules you want to `format` and copy the matching sections from `snippets/starship.toml`.

```toml
format = "$directory${custom.aws_on_command}${custom.kube_on_command}${custom.gcloud_on_command}${custom.python_on_command}${custom.memory_on_command}$character"
```

Disable native modules that would duplicate the custom ones:

```toml
[aws]
disabled = true

[kubernetes]
disabled = true

[gcloud]
disabled = true

[python]
disabled = true
```

## Defaults

```fish
set -g starship_soc_aws_commands aws awless cdk terraform terragrunt pulumi serverless sam
set -g starship_soc_kube_commands kubectl helm kubens kubectx oc istioctl k9s helmfile flux fluxctl stern
set -g starship_soc_gcloud_commands gcloud gsutil bq
set -g starship_soc_python_commands python python3 pip pip3 pipx uv poetry pdm conda mamba pytest tox ipython jupyter
set -g starship_soc_memory_commands top htop btop free vmstat
```

Override any list before the plugin loads, or in `config.fish` followed by a new shell.

## Commands

```fish
starship-soc status
starship-soc clear
starship-soc snippet
```

## Notes

- fish only
- no Starship fork
- no daemon
- state clears on command execution or cancel
- repaint runs only when active state changes
