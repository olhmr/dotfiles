# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#=:===========================================================================#
# basic                                                                       #
#=:===========================================================================#
# Make it less likely that we accidentally overwrite files with redirect, copy, or move
set -o noclobber
alias cp='cp -i'
alias mv='mv -i'

#-:---------------------------------------------------------------------------#
# initial                                                                     #
#-----------------------------------------------------------------------------#
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# p10k theme installed via oh-my-zsh
export ZSH_THEME="powerlevel10k/powerlevel10k"

# Encodings
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# tfenv for Apple Silicon
export TFENV_ARCH=arm64

# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Ensure history is saved between sessions
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory


#-:---------------------------------------------------------------------------#
# startup optimisation                                                        #
#-----------------------------------------------------------------------------#
# Only check cache dump once a day: https://medium.com/@dannysmith/little-thing-2-speeding-up-zsh-f1860390f92
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Improve compinit time in startup
skip_global_compinit=1


#=:===========================================================================#
# plugin and tooling config                                                   #
#=:===========================================================================#

#-:---------------------------------------------------------------------------#
# pyenv                                                                       #
#-----------------------------------------------------------------------------#
# (The below instructions are intended for common
# shell setups. See the README for more guidance
# if they don't apply and/or don't work for you.)

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:
#
# Only do it if starting a top-level shell
# See https://www.reddit.com/r/neovim/comments/ga0s7w/use_python_venv_with_neovim/

if [ "$SHLVL" = 1 ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  # Load pyenv into the shell by adding
  # the following to ~/.zshrc:

  eval "$(pyenv init -)"
fi


# Add flags from https://stackoverflow.com/questions/66482346/problems-installing-python-3-6-with-pyenv-on-mac-os-big-sur
export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"


#-:---------------------------------------------------------------------------#
# poetry                                                                      #
#-----------------------------------------------------------------------------#
if [ "$SHLVL" = 1 ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi


#-:---------------------------------------------------------------------------#
# google cloud sdk                                                            #
#-----------------------------------------------------------------------------#
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/olle.hammarstrom/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/olle.hammarstrom/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/olle.hammarstrom/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/olle.hammarstrom/google-cloud-sdk/completion.zsh.inc'; fi

# have kubectl use the new binary plugin for authentication instead of using the default provider-specific code
export USE_GKE_GCLOUD_AUTH_PLUGIN=True


#-:---------------------------------------------------------------------------#
# golang                                                                      #
#-----------------------------------------------------------------------------#
export PATH="$HOME/go/bin:$PATH"


#-:---------------------------------------------------------------------------#
# plugins                                                                     #
#-----------------------------------------------------------------------------#
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  autojump
  zsh-autosuggestions
)


#-:---------------------------------------------------------------------------#
# editing                                                                     #
#-----------------------------------------------------------------------------#
# Preferred editor
export EDITOR='nvim'


#-:---------------------------------------------------------------------------#
# FZF                                                                         #
#-----------------------------------------------------------------------------#
export FZF_DEFAULT_COMMAND='rg --files --hidden' # faster than the default
source <(fzf --zsh) # add fzf features for zsh
# TODO: this doesn't seem to work with oh-my-zsh, look into it


#=:===========================================================================#
# aliases                                                                     #
#=============================================================================#

#-:---------------------------------------------------------------------------#
# vim / neovim                                                                #
#-----------------------------------------------------------------------------#
alias v='nvim'

#-:---------------------------------------------------------------------------#
# searching                                                                   #
#-----------------------------------------------------------------------------#
function f() { # search files and open in vim
  nvim -o `fzf --preview 'bat --style numbers,changes --color=always {} | head -500' $@`
}
function fl() { # search only current directory and open in vim
  ls | f
}
function ff() { # search inside files and open in vim - https://www.reddit.com/r/commandline/comments/fu6zzp/search_file_content_with_fzf/fmb7frf?utm_source=share&utm_medium=web2x&context=3
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  nvim -o `rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"`
}


#-:---------------------------------------------------------------------------#
# git and github                                                              #
#-----------------------------------------------------------------------------#
alias glb='git branch -a | grep -v remote'
alias ghst='gh status'
alias ghprs='gh search prs --state=open --author=@me'
alias ghreviews='gh search prs --state=open --review-requested=@me'
alias glodag='git log --oneline --decorate --all --graph'


#-:---------------------------------------------------------------------------#
# dbt                                                                         #
#-----------------------------------------------------------------------------#
function dbtpp() {
  dbt --partial-parse $@
}


#-:---------------------------------------------------------------------------#
# bigquery cli                                                                #
#-----------------------------------------------------------------------------#
function bq_dry() {
  # Run dry run
  RESULT=$(bq query --dry_run $@)
  # Check if validation succeeded
  if [[ $RESULT == *"Query successfully validated"* ]]; then
    # Convert the number of bytes from dry run to gigabytes
    NUMBER=$(echo $RESULT | tr -dc '0-9')
    GB=$(echo "${NUMBER} / 1000000000" | bc)
    echo "Query successfully validated. Assuming the tables are not modified, running this query will process ${GB} gigabytes of data."
  else
    # Print the full message
    echo $RESULT
  fi
}

#-:---------------------------------------------------------------------------#
# taskwarrior                                                                 #
#-----------------------------------------------------------------------------#
function t() {
  task $@
}

function ts() {
  task sync
}

function ta() {
  task active
}

function tw() {
  task $1 mod wait:1h
}

function te() {
  # encrypt the description of a task
  task $1 mod des:"$(echo $(task _get $1.description) | base64)"
}

function td() {
  # decrypt the description of a task
  task $1 mod des:"$(echo $(task _get $1.description) | base64 --decode)"
}

function tae() {
  # add a task with base64 encoded description to make it less obvious to people glancing
  task add $(echo $1 | base64) ${@:2}
}

function tgd() {
  # base64 decode the description to read it again
  task _get $1.description | base64 --decode
}

function trd() {
  task ready
}

#-:---------------------------------------------------------------------------#
# keyboard maps                                                               #
#-----------------------------------------------------------------------------#
function ukm() {
  if [[ $* == *--reset* ]]
    then hidutil property --set '{"UserKeyMapping":[]}'
  elif [[ $* == *--swap-tilde* ]]
    # https://apple.stackexchange.com/questions/329085/tilde-and-plus-minus-%C2%B1-in-wrong-place-on-keyboard
    then sudo hidutil property --set '{"UserKeyMapping":[ {"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064}, {"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035} ]}'
  fi
}

#-:---------------------------------------------------------------------------#
# python                                                                      #
#-----------------------------------------------------------------------------#
function pydev() {
  if [[ $* == *--poetry* ]]
    then poetry add --group dev ipython pdbpp black flake8 isort mypy
  elif [[ $* == *--pip* ]]
    then pip install ipython pdbpp black flake8 isort mypy
  else
      echo "Invalid args"
  fi
}

#=:===========================================================================#
# additional                                                                  #
#=============================================================================#

#-:---------------------------------------------------------------------------#
# p10k                                                                        #
#-----------------------------------------------------------------------------#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


#-:---------------------------------------------------------------------------#
# sensitive config not publically shared                                      #
#-----------------------------------------------------------------------------#
source ~/workspace/dotfiles/.zshrc_private


#-:---------------------------------------------------------------------------#
# oh-my-zsh                                                                   #
#-----------------------------------------------------------------------------#
source $ZSH/oh-my-zsh.sh

# TODO
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
alias gpg_restart='gpg-connect-agent updatestartuptty /bye'
