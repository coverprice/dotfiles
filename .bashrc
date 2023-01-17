# .bashrc
# shellcheck disable=SC2034

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# alias python='/usr/bin/python3'

# This lets gpg-agent work correctly within tmux
# shellcheck disable=SC2155
export GPG_TTY=$(tty)
export SHELLCHECK_OPTS="-e SC1090 -e SC1091"
export FIGNORE=".o:__pycache__:.pyc"

export EDITOR=/usr/bin/vim

export PATH="${PATH}:${HOME}/.local/bin"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias .........="cd ../../../../../../../.."
alias ..........="cd ../../../../../../../../.."
alias ...........="cd ../../../../../../../../../.."
alias ............="cd ../../../../../../../../../../.."
alias .............="cd ../../../../../../../../../../../.."
alias tm="tmux attach || tmux"

COLOR_BLUE="\[\033[0;34m\]"
COLOR_LIGHT_BLUE="\[\033[0;36m\]"
COLOR_RED="\[\033[0;31m\]"
COLOR_LIGHT_RED="\[\033[1;31m\]"
COLOR_GREEN="\[\033[0;32m\]"
COLOR_LIGHT_GREEN="\[\033[1;32m\]"
COLOR_WHITE="\[\033[1;37m\]"
COLOR_LIGHT_GRAY="\[\033[0;37m\]"
COLOR_BLACK="\[\033[0;30m\]"
COLOR_RESET="\[\e[0m\]"

function viack() {
  # shellcheck disable=SC2046
  vi $(ack -l "$@")
}

function tempdir() {
  cd "$(mktemp -d)"
}

# Infra toolbox nav
# shellcheck disable=SC2155
export VENV_HOME="$(readlink -f "${HOME}/venvs")"
# shellcheck disable=SC2155
export REPO_HOME="$(readlink -f "${HOME}/repos")"
_infra_toolbox_nav=~/repos/infra-toolbox-nav/infra-toolbox_nav.sh
[[ -f $_infra_toolbox_nav ]] && source "${_infra_toolbox_nav}"

# Reset the time because the VM gets out of sync with the actual time.
function fix_time() {
  sudo systemctl restart systemd-timesyncd.service
}

function reset_openshift_config() {
  local - new_branch="$1"
  set -ex
  cd ~/openshift_config
  git checkout master
  git pull upstream master
  if [[ -n $new_branch ]] ; then
    git checkout -b "${new_branch}"
  fi
}
function roc() {
  reset_openshift_config "$@"
}

function randpw() {
  openssl rand -base64 32
}

function cdtop() {
  local git_top
  git_top="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ -n $git_top ]] ; then
    cd "${git_top}"
  else
    echo "Current directory is not in a git repo"
  fi
}

function prompt_update() {
  local branch git_top repo_name git_branch_prompt
  git_top="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ -n $git_top ]] ; then
    repo_name="$(basename "${git_top}")"
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    git_branch_prompt="$(printf "%s[%s%s %s%s] " "${COLOR_WHITE}" "${COLOR_RESET}" "${repo_name}" "${COLOR_WHITE}" "${branch}")"
  fi
  _ACTIVE_PROJECT_PROMPT=
  if [[ -n $git_top ]] && [[ $(type -t _active_project_prompt) == "function" ]]; then
     # Needs to be done outside of a sub-shell as it modifies vars
     _active_project_prompt "${git_top}"
  fi
  PS1="${git_branch_prompt}${_ACTIVE_PROJECT_PROMPT}${COLOR_GREEN}[${COLOR_LIGHT_GRAY}\\u ${COLOR_GREEN}${PWD/#${HOME}/\~}${COLOR_LIGHT_BLUE}]${COLOR_RESET}\\$ "
}
PROMPT_COMMAND=prompt_update
PS2='> '
PS4='+ '
