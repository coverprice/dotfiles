# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias python='/usr/bin/python3'

export KUBECONFIG=~/.secrets/kube-config-prod-v1472

function get_node_ip() {
  # Get a production node IP
  kubectl get nodes -o json \
   | jq -r '.items[] | select(.metadata.labels."node-role.kubernetes.io/node"=="")
   | .status.addresses[] | select(.type=="InternalIP")
   | .address' \
   | head -1
}

# Virtualenv / Virtualenvwrapper stuff
export WORKON_HOME="${HOME}/venvs"
export PROJECT_HOME="${HOME}/venvs"
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
[[ -f /usr/bin/virtualenvwrapper.sh ]] && source /usr/bin/virtualenvwrapper.sh

function work() {
  local venv=$1
  workon "${venv}"
  if [[ $? != 0 ]] ; then
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
