# dotfiles

Repository containing my tool configuration files.

Grabbing the latest version:

    pushd ~
    TMPDIR=$(mkdir -d)
    git clone --depth=1 https://github.com/coverprice/dotfiles.git ${TMPDIR}
    rm ${TMPDIR}/.git
    mv -f ${TMPDIR}/.[^.]* .
    popd
