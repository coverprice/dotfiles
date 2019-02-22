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

export KUBECONFIG=~/.secrets/kube-config-prod-v1472
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

function get_node_ip() {
  # Get a production node IP
  kubectl get nodes -o json \
   | jq -r '.items[] | select(.metadata.labels."node-role.kubernetes.io/node"=="")
   | .status.addresses[] | select(.type=="InternalIP")
   | .address' \
   | head -1
}

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
  if ! workon "${venv}" ; then
    return
  fi
  cd "${VIRTUAL_ENV}"
  echo "${VIRTUAL_ENV}" > ".venv"
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
  [[ -n $VIRTUAL_ENV ]] && printf "%s(%s) " "${COLOR_WHITE}" "$(basename "${VIRTUAL_ENV}")"
}


# Helper function for our fancy prompt.
function git_branch_prompt() {
  local branch
  branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's#* \(.*\)#\1#')
  if [[ -n $branch ]] ; then
    printf " %s%s " "${COLOR_WHITE}" "${branch}"
  fi
}

function prompt_update() {
  PS1="$(virtual_env_prompt)${COLOR_LIGHT_BLUE}[${COLOR_LIGHT_GRAY}\\u ${COLOR_GREEN}${PWD/#${HOME}/\~}${COLOR_LIGHT_BLUE}]$(git_branch_prompt)${COLOR_RESET}\$ "
}
PROMPT_COMMAND=prompt_update
PS2='> '
PS4='+ '
