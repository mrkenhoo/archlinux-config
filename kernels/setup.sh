#!/bin/sh		

[ ! -d "kernels/linux-tkg" ] && git clone https://github.com/frogging-family/linux-tkg.git && \
    cp -v "kernels/customization.cfg" "kernels/linux-tkg/customization.cfg"
