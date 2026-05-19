# starship-show-on-command.fish

Show Starship prompt context only when it is relevant to the command you are typing in fish.
It brings a Powerlevel10k-style [`SHOW_ON_COMMAND`](https://github.com/romkatv/powerlevel10k#show-on-command) workflow to Starship.

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

## Demo

```text
~/work/project
❯ a

~/work/project on ☁️ default (us-east-1)
❯ aws

~/work/project on ☸ staging/default
❯ kubectl

~/work/project on ☁️ default (us-east-1) on ☸ staging/default
❯ aws && kubectl

~/work/project on ☁️ user@example.com@my-project
❯ gcloud

~/work/project via  python 3.13.0 (.venv)
❯ pytest

```

## Defaults

```fish
set -g starship_soc_contexts aws kube gcloud python

set -g starship_soc_aws_commands aws awless cdk terraform terragrunt pulumi serverless sam
set -g starship_soc_kube_commands kubectl helm kubens kubectx oc istioctl k9s helmfile flux fluxctl stern
set -g starship_soc_gcloud_commands gcloud gsutil bq
set -g starship_soc_python_commands python python3 pip pip3 pipx uv poetry pdm conda mamba pytest tox ipython jupyter
```

Override any list before the plugin loads, or in `config.fish` followed by a new shell.

## Custom Context

```fish
set -a starship_soc_contexts customapp
set -g starship_soc_customapp_commands deploy preview
set -g starship_soc_customapp_label "custom app prod"
set -g starship_soc_customapp_style "bold magenta"
set -g starship_soc_customapp_format 'on [$output]($style) '
```

Typing `deploy` or `preview` will set `STARSHIP_SOC_CUSTOMAPP=1` and show the generated `custom.customapp_on_command` Starship module.

For dynamic context text, define a function:

```fish
function __starship_soc_customapp_context
    echo "custom app "(cat .environment)
end
```

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
- reevaluates command segments up to the cursor on each keystroke
- for each segment, reads only up to the first whitespace; arguments are not inspected
- starts matching again after fish process separators like `|`, `&&`, `||`, `;`, `&`, newlines, `and`, and `or`
- can show multiple contexts at once, for example `aws && python`
- no daemon
- state clears on command execution or cancel
- repaint runs only when active state changes
