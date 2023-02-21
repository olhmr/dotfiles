# dotfiles

Dotfiles for personal use. Current stack:

- iterm2 as terminal
- zsh with oh-my-zsh p10k as shell
- neovim for editing
- visidata for spreadsheets
- taskwarrior for task management

# Installation notes
All for macOS

Install iterm2: https://iterm2.com/
Install homebrew: https://brew.sh/
Install zsh: `brew install zsh`
Install oh-my-zsh: https://ohmyz.sh/#install
Install zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
Install autojump: `brew install autojump`
Install pyenv: `brew install pyenv`

## iTerm2

Import the colorscheme from this repo.

In Mac Settings -> Keyboard -> Keyboard Shortcuts -> App Shortcuts, add a shortcut for iTerm called `Close` set to `cmd + shift + w`. This will ensure that `cmd + w` doesn't close tabs or windows.

Download the patched `Fantasque Sans Mono` nerd font - *not* the one from nerdfonts.com: https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FantasqueSansMono/Regular/complete/Fantasque%20Sans%20Mono%20Regular%20Nerd%20Font%20Complete.ttf

Double-click the file to add to Mac.

Change font in iTerm to use new font, and set size to 14.

## neovim
Helpful info on neovim config in lua:
- https://neovim.io/doc/user/lua.html
- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

Install neovim:
```
  $ brew install neovim
```

Install vim-plug: https://github.com/junegunn/vim-plug

Copy `nvim/` to `~/.config/`

Create `~/.config/nvim/python-env` and navigate there

Ensure `pyenv` is installed and version 3.9.11 is available (if not: `pyenv install 3.9.11`)

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
  :MasonInstall lua-language-server
```

#### Python

```
  :MasonInstall pyright
```

#### Scala

See https://github.com/scalameta/nvim-metals

# Other tooling

- [Spectacle](https://github.com/eczarny/spectacle) for multiplexing
- [Raycast](https://www.alfredapp.com/) for better spotlight search
  Add `cmd + shift + v` as a shortcut for the `Clipboard History` extension
- [f.lux](https://justgetflux.com/) as a blue-light filter
- [Hammerspoon](https://www.hammerspoon.org/) for when I don't have my external keyboard
