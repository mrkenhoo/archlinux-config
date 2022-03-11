#!/bin/sh

[ ! -f "/usr/bin/git" ] && sudo pacman -S git --needed --noconfirm

[ ! -d "packages/yay" ] && git -C "packages" clone https://aur.archlinux.org/yay.git && \
	cd "packages/yay" && makepkg -csi --needed --noconfirm && cd ..

[ -d "packages/proton-ge-custom-updater" ] && \
	cd "packages/proton-ge-custom-updater" && makepkg -csi --needed --noconfirm && cd ..

[ -f "packages/pkglist" ] && cd "packages"; \
	yay -Syu --needed --noconfirm - < pkglist