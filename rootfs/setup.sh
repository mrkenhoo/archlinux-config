#!/bin/sh

for f in rootfs/boot/loader/entries/*.conf; do
    printf "\n:: Copying file ${f} to /boot/loader/entries/..."
    cp "${f}" "/boot/loader/entries/"
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

lsblk && read -p ":: Where is the root partition mounted at? (e.g. /dev/sda1): " root_device
if [ ! -z "${root_device}" ]; then
    for f in /boot/loader/entries/*.conf; do
        printf "\n:: Setting up PARTUUID for ${root_device} on file ${f}..."
        sed "s/PARTUUID=<enter_partuuid_here>/PARTUUID=`blkid -s PARTUUID -o value ${root_device}`/g" -i "${f}"
        [ $? = "0" ] && printf " done\n" || printf " failed\n"
    done
else
    echo ":: ERROR: No root device was specified"
    exit 1
fi

for f in rootfs/etc/modprobe.d/*.conf; do
    printf "\n:: Copying file ${f} to /etc/modprobe.d..."
    cp "${f}" "/etc/modprobe.d/"
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/etc/pacman.d/*; do
    printf "\n:: Populating pacman mirrorlist..."
    cat "${f}" | sudo tee "/etc/pacman.d/mirrorlist"
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done


for f in rootfs/etc/profile.d/*.sh; do
    printf "\n:: Copying file ${f} to /etc/profile.d/..."
    cp "${f}" "/etc/profile.d/"
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/etc/sysctl.d/*.conf; do
    printf "\n:: Copying file ${f} to /etc/sysctl.d/..."
    cp -v "${f}" "/etc/sysctl.d/"
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

printf "\n:: Copying file environment to /etc/..."
cp -v "rootfs/etc/environment" "/etc/"
[ $? = "0" ] && printf " done\n" || printf " failed\n"

printf "\n:: Copying file rootfs/home/.config/modprobed.db to ~/.config/..."
cp "rootfs/home/.config/modprobed.db" "~/.config"
[ $? = "0" ] && printf " done\n" || printf " failed\n"

curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
sed 's/ZSH_THEME="."/ZSH_THEME="powerlevel10k/powerlevel10k"/g' -i ~/.zshrc

if [ $? = "0" ]; then
    echo "source /etc/profile
source /etc/environment

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -Uz compinit
compinit" | tee -a /home/${username}/.zshrc
else
    echo ":: ERROR: 'Oh My Zsh' installation failed"
fi
