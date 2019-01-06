#!/bin/bash

set -e -x -o pipefail
# shellcheck disable=SC2046
HERE=$(dirname $(readlink -f "${0}"))
cd "${HERE}"

cp -pR \
    .bash_profile \
    .bashrc \
    .config \
    .dir_colors \
    .gitconfig \
    .screenrc \
    .tmux.conf \
    .vimrc \
  ~/

BUNDLE_DIR=~/.vim/bundle
mkdir -p ~/.vim/autoload "${BUNDLE_DIR}"
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
git clone --depth=1 https://github.com/pangloss/vim-javascript.git "${BUNDLE_DIR}/vim-javascript"
git clone --depth=1 https://github.com/leshill/vim-json.git "${BUNDLE_DIR}/vim-json"
git clone --depth=1 https://github.com/mxw/vim-jsx.git "${BUNDLE_DIR}/vim-jsx"
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git "${BUNDLE_DIR}/syntastic"

sudo dnf install -y ShellCheck python3-flake8
