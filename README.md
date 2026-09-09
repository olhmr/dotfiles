# dotfiles

Personal configuration for zsh, tmux, kitty, neovim, visidata and the
Claude Code agent scripts.

Installation **links**, it does not copy. An edit made live is an edit to the
repo, and `git status` tells the truth. Copying is what let four months of
config edits drift out of git unnoticed.

## Layout

| Directory | Holds |
|-----------|-------|
| `zsh/` | `.zshrc`, `.p10k.zsh`, an example private overrides file |
| `tmux/` | `.tmux.conf`, including the agent status bar |
| `kitty/` | `kitty.conf` |
| `nvim/` | `init.lua`, snippets, `after/` syntax |
| `claude/bin/` | The `agent-*` inbox scripts |
| `visidata/` | `.visidatarc` |
| `iterm/` | Old iTerm2 colour schemes, kept for reference |
| `macos/` | Hammerspoon config |

## Install

```bash
make backup   # copies every path the install will touch
make link     # replaces those paths with links into this repo
make doctor   # reports any path that is not the link it should be
```

`make doctor` is how drift gets caught next time. It exits non-zero if any
path is a real file where a link is expected.

`make unlink` removes only the links this Makefile made. It does not restore
the originals, so restore those from `~/dotfiles-backups/<stamp>`.

## The private repo

This repo is public. Anything that names an employer system, a project id, a
ticket or a colleague lives in a separate private repo instead. That is the
rule, so the decision does not need making again each time.

Private config lives in `dotfiles-private`, expected at
`~/workspace/personal/dotfiles-private`. Override the path:

```bash
make link PRIVATE=/some/other/path
```

It holds the agent settings file, the global instructions file, the hooks
directory, the statusline script and `.zshrc_private`.

### Deliberately not tracked anywhere

- `hooks/card.log` records prompts verbatim, including ticket references. It
  also grows with every prompt.
- `nvim/python-env/`, a virtualenv. Recreate it, see below.
- `~/.claude/` itself, apart from the config paths. The agent writes sessions,
  jobs, projects and backups there.

## Prerequisites

Install Homebrew first: https://brew.sh/

```bash
brew bundle --file=Brewfile
```

`make brew-dump` refreshes the `Brewfile` from the current machine.

### kitty

Install with the official installer, not Homebrew, because the cask lags:

```bash
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/Contents/MacOS/kitty  ~/.local/bin/kitty
ln -sf ~/.local/kitty.app/Contents/MacOS/kitten ~/.local/bin/kitten
```

**Terminfo.** `xterm-kitty` is not in the system terminfo database. That only
matters over ssh, where `kitten ssh` sends the entry across for you. Use
`kitten ssh <host>`, not `ssh <host>`.

### Fonts

A missing font is the most likely cause of a broken first run. Install both
patched Fantasque Sans Mono faces from ryanoasis/nerd-fonts, not the ones
from nerdfonts.com:

1. `FantasqueSansMNerdFontMono-Regular.ttf`, the general font.
2. `FantasqueSansMNerdFont-Regular.ttf`, for icons.

The second is needed because the mono face renders icons too small.

### tmux

Install tmux, then tpm: https://github.com/tmux-plugins/tpm

### neovim

The python provider needs a virtualenv inside the config directory. It is
gitignored, so create it after linking:

```bash
cd nvim && mkdir -p python-env && cd python-env
pyenv local 3.9.11
python3 -m venv env
./env/bin/python3 -m pip install pynvim
```

Install vim-plug (https://github.com/junegunn/vim-plug), open neovim, run
`:PlugInstall`.

Install ripgrep and fd for telescope performance. Check with
`:checkhealth telescope`.

Treesitter is deliberately unused. Its SQL highlighting was inconsistent, and
it has no jinja2 or dbt support.

Language servers, through Mason:

```
:MasonInstall lua-language-server
:MasonInstall pyright
```

For Scala, see https://github.com/scalameta/nvim-metals

## Other tooling

- [Raycast](https://www.raycast.com/) for search. Bind `cmd + shift + v` to
  the Clipboard History extension.
- [f.lux](https://justgetflux.com/) as a blue-light filter.
