# starship-show-on-command.fish

Show selected Starship custom modules only while typing matching commands in fish.

## Install

You can install using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install chelokot/starship-show-on-command.fish
starship-soc install
exec fish
```

`starship-soc install` updates `$STARSHIP_CONFIG` or `~/.config/starship.toml`.
It is interactive: it shows the config path, creates a backup, and asks before adding custom modules, changing top-level `format`, or hiding always-on Starship modules that would show the same context twice.

For non-interactive setup:

```fish
starship-soc install --yes
```

To configure manually:

```fish
starship-soc snippet
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
starship-soc install
starship-soc install --yes
starship-soc uninstall
```

## Notes

- fish only
- no Starship fork
- no daemon
- state clears on command execution or cancel
- repaint runs only when active state changes
