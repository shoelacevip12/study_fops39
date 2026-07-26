#!/bin/bash

mkdir -vp /home/namespace/box/{bin,lib,lib64,proc}

cp -v /bin/{ls,bash} /home/namespace/box/bin
cp -v /usr/bin/{kill,ps} /home/namespace/box/bin

cp -r /lib/* /home/namespace/box/lib
cp -vr /lib64/* /home/namespace/box/lib64

mount -t proc /proc /home/namespace/box/proc

chroot /home/namespace/box /bin/bash
