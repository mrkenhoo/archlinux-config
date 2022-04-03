#!/bin/sh		

[ ! -d "kernels/linux-tkg" ] && \
    git -C "kernels" clone https://github.com/frogging-family/linux-tkg.git && \
    cp -v "kernels/customization.cfg" "kernels/linux-tkg/customization.cfg" && \
    cd "kernels/linux-tkg" && makepkg -csi --needed && cd "../.." || \
    cp -v "kernels/customization.cfg" "kernels/linux-tkg/customization.cfg" && \
    cd "kernels/linux-tkg" && \
    sh update-kernel-versions.sh && \
    makepkg -csi --needed && \
    cd ../..
