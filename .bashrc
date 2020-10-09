# .bashrc
# shellcheck disable=SC2034

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias python='/usr/bin/python3'

# This lets gpg-agent work correctly within tmux
# shellcheck disable=SC2155
export GPG_TTY=$(tty)
export SHELLCHECK_OPTS="-e SC1090 -e SC1091"
export FIGNORE=".o:__pycache__:.pyc"

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

# Virtualenv / Virtualenvwrapper stuff
export WORKON_HOME="${HOME}/venvs"
export PROJECT_HOME="${HOME}/venvs"
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
[[ -f /usr/bin/virtualenvwrapper.sh ]] && source /usr/bin/virtualenvwrapper.sh

function work() {
  local - venv=$1
  set -e
  if [[ -z $venv ]] ; then
    echo "You must specify a virtualenv name."
    return
  fi
  if ! workon "${venv}" ; then
    echo "Could not switch to virtualenv '${venv}'"
    return
  fi
  cd "${VIRTUAL_ENV}"
  echo "${VIRTUAL_ENV}" > ".venv"
  # shellcheck disable=SC2155
  local src_top="$(readlink -f "./li/tools/src")"
  if [[ -d $src_top ]] ; then
    cd "${src_top}"
    export CDPATH=".:${src_top}:${src_top}/atlas"
  fi
}

function cdat() {
  local - dir="${VIRTUAL_ENV}/li/tools/src/atlas"
  [[ -d $dir ]] && cd "${dir}"
}

function cdlibs() {
  local - dir="${VIRTUAL_ENV}/lib/python3.7/site-packages"
  [[ -d $dir ]] && cd "${dir}"
}

function cddpp() {
  local - dir="${VIRTUAL_ENV}/li/tools/src/dpp"
  [[ -d $dir ]] && cd "${dir}"
}

function cdsrc() {
  local - dir="${VIRTUAL_ENV}/li/tools/src"
  [[ -d $dir ]] && cd "${dir}"
}

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

# Looks for a .venv file in the PWD or above, and activates it. Used when tmux
# creates a new pane in the current directory, which by default won't inherit
# the current virtualenv environment.
function virtualenv_auto_activate() {
  local cur_dir
  cur_dir=$(readlink -f "${PWD}")
  while [[ $cur_dir =~ ^"${HOME}" ]]; do
    if [[ -f "${cur_dir}/.venv" ]] && [[ -f "${cur_dir}/bin/activate" ]] ; then
      source "${cur_dir}/bin/activate"
      return
    else
      cur_dir=$(dirname "${cur_dir}")
    fi
  done
}
virtualenv_auto_activate

function virtual_env_prompt() {
  [[ -n $VIRTUAL_ENV ]] && printf "%s(%s) " "${COLOR_LIGHT_BLUE}" "$(basename "${VIRTUAL_ENV}")"
}


# Helper function for our fancy prompt.
function git_branch_prompt() {
  local branch
  branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's#* \(.*\)#\1#')
  if [[ -n $branch ]] ; then
    printf "%s%s " "${COLOR_WHITE}" "${branch}"
  fi
}

function prompt_update() {
  PS1="$(virtual_env_prompt)$(git_branch_prompt)${COLOR_LIGHT_BLUE}[${COLOR_LIGHT_GRAY}\\u ${COLOR_GREEN}${PWD/#${HOME}/\~}${COLOR_LIGHT_BLUE}]${COLOR_RESET}\\$ "
}
PROMPT_COMMAND=prompt_update
PS2='> '
PS4='+ '
