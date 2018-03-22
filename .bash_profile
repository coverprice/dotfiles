# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

# This lets gpg-agent work correctly within tmux
export GPG_TTY=$(tty)
export GOPATH=$HOME/gocode
PATH=$PATH:$HOME/.local/bin:$HOME/bin:$GOPATH/bin

export PATH

export FIGNORE=".o:~:.pyc:.pyo"
# original: PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
export PROMPT_COMMAND='printf "\033k%s\033\\" "${PWD/#$HOME/\~}"'

export TERM=xterm-256color
# Stop Ctrl-Q and Ctrl-S from messing up terminals
stty start undef
stty stop undef

