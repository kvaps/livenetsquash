# Livenetsquash dracut module

This module allows to boot live linux system from squashed image that downloaded from http-server.

I advise you to use [darkhttpd](https://github.com/ryanmjacobs/darkhttpd) as simple http server for store your squased image.

## Installation
```
cd /tmp
curl -OL https://github.com/kvaps/livenetsquash/archive/master.tar.gz
tar xvf master.tar.gz
mv livenetsquash-master/dracut/* /usr/lib/dracut/modules.d/
rm -rf livenetsquash-master master.tar.gz
vim /etc/dracut.conf
```

add modules:
```
dracutmodules+="network base livenetsquash overlay-root"
```

## Bootloader configuration

Example `pxelinux.cfg/default`

```
default centos7
ontimeout centos7

label centos7
    kernel vmlinuz
    append initrd=initramfs selinux=0 root=live:http://boot-server/rootfs.squash rootovl=1 ro rd.live.image
```

Example `grub.cfg` (support efi and http-method)

```
set timeout=3
menuentry 'Linux diskless' --class os {

     insmod efi_gop
     insmod efi_uga

     set net_default_server=${pxe_default_server}

     echo "Loading Linux from http://${net_default_server}/vmlinz ..."
     linux (http)/vmlinuz root=live:http://${pxe_default_server}/rootfs.squash rootovl=1 ro rd.live.image

     echo "Loading initial ramdisk from http://${pxe_default_server}/initramfs ..."
     initrd (http)/initramfs
}
```
