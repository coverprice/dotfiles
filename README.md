# dotfiles

Repository containing my tool configuration files.

Grabbing the latest version:

    pushd ~ \
    && git clone --depth=1 https://github.com/coverprice/dotfiles.git tmpdotfiles \
    && mv -f tmpdotfiles/.[^.]* . \
    && rm -rf tmpdotfiles \
    && popd
