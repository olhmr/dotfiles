# dotfiles

Dotfiles for personal use. Current stack:

- zsh with p10k as shell
- neovim for editing
- visidata for spreadsheets
- taskwarrior for task management

# Installation notes
All for macOS

## neovim
Helpful info on neovim config in lua:
- https://neovim.io/doc/user/lua.html
- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

Install neovim:
```
  $ brew install neovim
```

Copy `nvim/` to `~/.config/`

Create `~/.config/nvim/python-env` and navigate there

Install `pyenv`

Run:
```
  $ pyenv local 3.9.11
  $ python3 -m venv env
  $ /Users/<user>/.config/nvim/python-env/env/bin/python3 -m pip install pynvim
```

Open neovim and run `:PlugInstall`

For improved performance when fuzzy finding, ensure ripgrep and fd are installed (see `:checkhealth telescope` after installing telescope)

There are two reasons for not using treesitter:
- ran into some bugs with the highlights being inconsistent (e.g., for SQL highlighting the alias after `AS` differently on different lines)
- no support for jinja2 / dbt

### LSPs

#### Lua

```
  $ brew install lua-language-server
```

(Can also be installed via Mason)

#### Python

```
  :MasonInstall pyright
```

#### Scala

See https://github.com/scalameta/nvim-metals

# Other tooling

- [Spectacle](https://github.com/eczarny/spectacle) for multiplexing
- [Alfred](https://www.alfredapp.com/) for better spotlight search
- [f.lux](https://justgetflux.com/) as a blue-light filter
- [Clipy](https://github.com/Clipy/Clipy) for clipboard with history
- [Hammerspoon](https://www.hammerspoon.org/) for when I don't have my external keyboard
