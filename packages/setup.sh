#!/bin/sh

[ -z "${username}" ] && read -p ":: Type your username (e.g. foo): " username
[ -z "${user_password}" ] && read -p ":: Type a password for ${username}: " user_password

echo ":: Creating user ${username}..."
useradd -m -s /bin/zsh "${username}"

echo ":: Setting up password for ${username}..."
echo "${username}:${user_password}" | chpasswd

export username="${username}"

[ ! -x "/usr/bin/git" ] && sudo pacman -S git --needed --noconfirm

[ ! -d "packages/yay" ] && git -C "packages" clone https://aur.archlinux.org/yay.git && \
	cd "packages/yay" && sudo -u ${username} makepkg -csi --needed --noconfirm && cd ..

[ -d "packages/proton-ge-custom-updater" ] && \
	cd "packages/proton-ge-custom-updater" && \
	sudo -u ${username} makepkg -csi --needed --noconfirm && cd ..

[ -f "packages/pkglist" ] && \
	sudo -u ${username} yay -Syu --needed --noconfirm - < packages/pkglist
