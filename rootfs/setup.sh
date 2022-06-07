#!/bin/sh

for f in rootfs/boot/loader/entries/*.conf; do
	sudo cp -v "${f}" "/boot/loader/entries/"
done

lsblk && read -p ":: Where is the root partition mounted at? (e.g. /dev/sda1): " root_device
if [ ! -z "${root_device}" ]; then
    for f in /boot/loader/entries/*.conf; do
        sed "s/PARTUUID=<enter_partuuid_here>/PARTUUID=`blkid -s PARTUUID -o value ${root_device}`/g" -i "${f}"
    done
else
    echo ":: ERROR: No root device was specified"
    exit 1
fi

for f in rootfs/etc/modprobe.d/*.conf; do
    sudo cp -v "${f}" "/etc/modprobe.d/"
done

for f in rootfs/etc/pacman.d/*; do
    cat "${f}" | sudo tee "/etc/pacman.d/mirrorlist"
done

for f in rootfs/etc/profile.d/*.sh; do
    sudo cp -v "${f}" "/etc/profile.d/"
done

for f in rootfs/etc/sysctl.d/*.conf; do
    sudo cp -v "${f}" "/etc/sysctl.d/"
done

sudo cp -v "rootfs/etc/environment" "/etc/"

read -p "Type your username (e.g. foo): " username

cp -v "rootfs/home/.config/modprobed.db" "/home/${username}/.config"

[ ! -z "${username}" ] && chsh -s /bin/zsh "${username}" && \
    [ ! -f "/home/${username}/.zshrc" ] && \
    printf 'source /etc/profile
source /etc/environment

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -Uz compinit
compinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' > "/home/${username}/.zshrc" || \
    echo "No username specified, zsh was not configured"
