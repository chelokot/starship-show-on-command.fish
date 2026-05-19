# starship-show-on-command.fish

Show selected Starship custom modules only while typing matching commands in fish.

## Install

```fish
fisher install chelokot/starship-show-on-command.fish
starship-soc install
exec fish
```

`starship-soc install` updates `$STARSHIP_CONFIG` or `~/.config/starship.toml`.
It adds a managed custom-module block, inserts the modules into top-level `format`, and disables duplicate native modules.

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
starship-soc install
starship-soc uninstall
```

## Notes

- fish only
- no Starship fork
- no daemon
- state clears on command execution or cancel
- repaint runs only when active state changes
