#!/bin/sh

if [ ! -f "tools/linux-utils" ]
then
    git -C "tools" https://github.com/mrkenhoo/linux-utils.git
fi
