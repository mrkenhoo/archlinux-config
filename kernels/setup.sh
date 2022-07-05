#!/bin/sh		

if [ ! -d "kernels/linux-tkg" ]
then
    git -C "kernels" clone https://github.com/frogging-family/linux-tkg.git
    if [ ! -f "kernels/customization.cfg" ]
    then
        echo ":: ERROR: Could not find the file 'kernels/customization.cfg'"
        exit 1
    else
        cp -v "kernels/customization.cfg" "kernels/linux-tkg/customization.cfg"
    fi
    cd "kernels/linux-tkg" && makepkg -cisr --needed && cd ../..
else
    if [ ! -f "kernels/linux-tkg/update-kernel-versions.sh" ]
    then
        echo ":: ERROR: Could not find the file kernels/linux-tkg/update-kernel-versions.sh"
        exit 1
    else
        cd "kernels/linux-tkg" && sh update-kernel-versions.sh && cd ../..
    fi
fi

