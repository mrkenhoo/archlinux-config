#!/bin/sh

for f in rootfs/boot/loader/entries/*.conf; do
    printf "\n:: Copying file ${f} to /boot/loader/entries/..."
    sudo cp "${f}" "/boot/loader/entries/" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

lsblk || exit 1

read -p ":: Where is the root partition mounted at? (e.g. /dev/sda1): " root_device
if [ ! -z "${root_device}" ]; then
    for f in /boot/loader/entries/*.conf; do
        printf "\n:: Setting up PARTUUID for ${root_device} on file ${f}..."
        sudo sed "s/PARTUUID=<enter_partuuid_here>/PARTUUID=`blkid -s PARTUUID -o value ${root_device}`/g" -i "${f}"
        [ $? = "0" ] && printf " done\n" || printf " failed\n"
    done
else
    echo ":: ERROR: No root device was specified"
    exit 1
fi

for f in rootfs/etc/modprobe.d/*.conf; do
    printf "\n:: Copying file ${f} to /etc/modprobe.d..."
    sudo cp "${f}" "/etc/modprobe.d/" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

printf "\n:: Populating pacman mirrorlist..."
cat "rootfs/etc/pacman.d/mirrorlist" | sudo tee "/etc/pacman.d/mirrorlist"
[ $? = "0" ] && printf " done\n" || printf " failed\n"

for f in rootfs/etc/profile.d/*.sh; do
    printf "\n:: Copying file ${f} to /etc/profile.d/..."
    sudo cp "${f}" "/etc/profile.d/"
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/etc/sysctl.d/*.conf; do
    printf "\n:: Copying file ${f} to /etc/sysctl.d/..."
    sudo cp "${f}" "/etc/sysctl.d/" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/etc/*; do
    [ ! -f "${f}" ] && break
    printf "\n:: Copying file ${f} to /etc/..."
    sudo cp "${f}" "/etc/" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/home/.config/*; do
    printf "\n:: Copying file ${f} to /home/`whoami`/.config/..."
    sudo cp "${f}" "/home/`whoami`/home/.config/" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
sed 's,ZSH_THEME=".",ZSH_THEME="powerlevel10k/powerlevel10k",g' -i "/home/`whoami`/.zshrc"

if [ $? = "0" ]; then
    [ -f "/home/`whoami`/.zshrc" ] && echo "source /etc/profile
source /etc/environment

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -Uz compinit
compinit" | tee -a "/home/`whoami`/.zshrc"
else
    echo ":: ERROR: The installation of 'Oh My Zsh' failed"
fi

