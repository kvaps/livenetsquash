#!/bin/bash
# module-setup.sh for livenet

check() {
    return 255
}

depends() {
    echo network url-lib img-lib
    return 0
}

installkernel() {
    instmods squashfs loop
}

install() {
    inst_multiple umount dmsetup blkid dd losetup grep blockdev
    inst_hook cmdline 29 "$moddir/parse-livenet.sh"
    inst_hook initqueue/online 95 "$moddir/fetch-liveupdate.sh"
    inst_script "$moddir/livenetroot.sh" "/sbin/livenetroot"
    dracut_need_initqueue
}

