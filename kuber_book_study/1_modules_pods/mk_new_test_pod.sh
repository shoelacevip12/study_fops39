#!/bin/bash

mkdir -vp /home/namespace/box/{bin,lib,lib64,proc}

cp -v /bin/{ls,bash} /home/namespace/box/bin
cp -v /usr/bin/{kill,ps,ip} /home/namespace/box/bin
cp -vr /usr/bin/curl /home/namespace/box/bin

cp -r /lib/* /home/namespace/box/lib
cp -vr /lib64/* /home/namespace/box/lib64

mount -t proc /proc /home/namespace/box/proc

# для изоляции процессов и файловых дескрипторов в chroot окружении
# unshare -p -f --mount-proc=home/namespace/box/proc

# для изоляции сетевого пространства имен в chroot окружении
# unshare -p -n -f --mount-proc=/home/namespace/box/proc

chroot /home/namespace/box /bin/bash
