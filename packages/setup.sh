#!/bin/sh

install_aur_packages()
{
    if [ ! -d "packages/proton-ge-custom-updater" ]
    then
        mkdir -v "packages/proton-ge-custom-updater"
        cd "packages/proton-ge-custom-updater" && \
            curl -fsSL https://raw.githubusercontent.com/p-mng/proton-ge-custom-updater/master/PKGBUILD/PKGBUILD \
                -o PKGBUILD && \
                makepkg -csir --needed --noconfirm && \
                cd ../..
    else
        cd "packages/proton-ge-custom-updater" && \
            makepkg -csir --needed --noconfirm && \
            cd ../..
    fi
    if [ ! -d "packages/yay" ]
    then
        git -C "packages" clone https://aur.archlinux.org/yay.git && \
            cd "packages/yay" && \
            makepkg -csir --needed --noconfirm && \
            cd ../..
    else
        cd "packages/yay" && \
            makepkg -csir --needed --noconfirm && \
            cd ../..
    fi
    if [ ! -f "packages/pkglist" ]
    then
        echo ":: ERROR: Could not find the file packages/pkglist"
    else
        `which yay` -Syu --needed `cat packages/pkglist`
        `which yay` -Ycc --noconfirm
    fi
    return $?
}

if [ ! -x "/usr/bin/git" ]
then
    sudo pacman -S git --needed --noconfirm
else
    install_aur_packages
fi

[ $? != "0" ] && exit 1

