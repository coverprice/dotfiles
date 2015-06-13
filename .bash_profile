# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
PATH=$PATH:$HOME/bin
GPG_TTY=$(tty)
export GPG_TTY

export FIGNORE=".o:~:.pyc:.pyo"

# Stop Ctrl-Q and Ctrl-S from messing up terminals
stty start undef
stty stop undef

# Prevent Gnu Screen from locking when there's no password to unlock it.
export LOCKPRG=/bin/true

# Ensures that this is visible to gnu-screen
export SHELL

export PATH
git config --global core.excludesfile ~/.gitignore_global

alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias vi='vim'
alias sc='systemctl'
alias sreload='systemctl daemon-reload'
alias srestart='systemctl restart'

# Workaround for an odd problem where systemd-nspawn will dump you into the root directory
cd ~
