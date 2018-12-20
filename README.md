# dotfiles

Repository containing my tool configuration files.

Grabbing the latest version:

    bash -s -ex <<"EOF"
    set -e -x -o pipefail
    cd ~
    TMPDIR=$(mktemp -d)
    git clone --depth=1 https://github.com/coverprice/dotfiles.git ${TMPDIR}
    rm -rf ${TMPDIR}/.git
    mv -f ${TMPDIR}/.[^.]* .
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    cd ~/.vim/bundle
    git clone --depth=1 https://github.com/vim-syntastic/syntastic.git
    EOF
