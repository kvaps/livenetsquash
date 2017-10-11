#!/bin/sh

# make a read-only nfsroot writeable by using overlayfs
# the nfsroot is already mounted to $NEWROOT
# add the parameter rootovl to the kernel, to activate this feature

. /lib/dracut-lib.sh

if ! getargbool 0 rootovl ; then
    return
fi

modprobe overlay

# a little bit tuning
mount -o remount,nolock,noatime $NEWROOT

# Move root
# --move does not always work. Google >mount move "wrong fs"< for
#     details
mkdir -p /live/image
mount --bind $NEWROOT /live/image
umount $NEWROOT

# Create tmpfs
mkdir /cow
mount -n -t tmpfs -o mode=0755 tmpfs /cow
mkdir /cow/work /cow/rw

# Merge both to new Filesystem
mount -t overlay -o noatime,lowerdir=/live/image,upperdir=/cow/rw,workdir=/cow/work,default_permissions overlay $NEWROOT

# Let filesystems survive pivot
mkdir -p $NEWROOT/live/cow
mkdir -p $NEWROOT/live/image
mount --bind /cow/rw $NEWROOT/live/cow
umount /cow
mount --bind /live/image $NEWROOT/live/image
umount /live/image
