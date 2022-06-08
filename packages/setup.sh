#!/bin/sh
[ ! -x "/usr/bin/git" ] && sudo pacman -S git --needed --noconfirm

[ ! -d "packages/yay" ] && git -C "packages" clone https://aur.archlinux.org/yay.git && \
	cd "packages/yay" && sudo -u `whoami` makepkg -csi --needed --noconfirm && cd ..

[ -d "packages/proton-ge-custom-updater" ] && \
	cd "packages/proton-ge-custom-updater" && \
	sudo -u `whoami` makepkg -csi --needed --noconfirm && cd ..

[ -f "packages/pkglist" ] && \
	sudo -u `whoami` yay -Syu --needed --noconfirm - < packages/pkglist
