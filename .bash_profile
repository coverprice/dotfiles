# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
PATH=$PATH:$HOME/bin
export GPG_TTY=$(tty)
export GOPATH=$HOME/gocode
PATH=$PATH:$HOME/.local/bin:$HOME/bin:$GOPATH/bin

export FIGNORE=".o:~:.pyc:.pyo"

# original: PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
export PROMPT_COMMAND='printf "\033k%s\033\\" "${PWD/#$HOME/\~}"'

# Stop Ctrl-Q and Ctrl-S from messing up terminals
stty start undef
stty stop undef

# Prevent Gnu Screen from locking when there's no password to unlock it.
export LOCKPRG=/bin/true

# Ensures that this is visible to gnu-screen
export SHELL

export PATH
git config --global core.excludesfile ~/.gitignore_global

alias sc='systemctl'
alias sreload='systemctl daemon-reload'
alias srestart='systemctl restart'

# Clone the latest dotfiles into the home directory
function get_dotfiles() {
    set -ex
    pushd ~
    TMPDIR=$(mkdir -d)
    git clone --depth=1 https://github.com/coverprice/dotfiles.git ${TMPDIR}
    rm ${TMPDIR}/.git
    mv -f ${TMPDIR}/.[^.]* .
    popd
}
